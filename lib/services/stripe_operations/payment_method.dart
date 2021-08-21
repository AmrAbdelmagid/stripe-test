import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_test/widgets/home_widget.dart';

class PaymentMethodOperations {
  double totalCost = 10.0;
  double tip = 1.0;
  double tax = 0.0;
  double taxPercent = 0.2;
  int amount = 0;

  // check if device is native pay ready
  void checkIfNativePayReady(context) async {
    print('started to check if native pay ready');
    bool? deviceSupportNativePay =
        await StripePayment.deviceSupportsNativePay();
    bool? isNativeReady = await StripePayment.canMakeNativePayPayments(
        ['american_express', 'visa', 'maestro', 'master_card']);
    deviceSupportNativePay! && isNativeReady!
        ? createPaymentMethodNative(context)
        : createPaymentMethod(context);
  }

  // create native Stripe payment method (is customized here for Android)
  Future<void> createPaymentMethodNative(context) async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount('');
    List<LineItem> items = [];
    items.add(LineItem(
      description: 'Demo Order',
      totalPrice: totalCost.toString(),
    ));
    if (tip != 0.0)
      items.add(LineItem(
        description: 'Tip',
        totalPrice: tip.toString(),
      ));
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(LineItem(
        description: 'Tax',
        totalPrice: tax.toString(),
      ));
    }
    items.add(LineItem(
      description: 'Vendor A',
      totalPrice: (totalCost + tip + tax).toString(),
    ));
    amount = ((totalCost + tip + tax) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod? paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
        currencyCode: 'GBP',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'GB',
        currencyCode: 'GBP',
        items: [],
      ),
    );
    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }

  Future<void> createPaymentMethod(context) async {
    StripePayment.setStripeAccount('');
    tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    amount = ((totalCost + tip + tax) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod? paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }
}
