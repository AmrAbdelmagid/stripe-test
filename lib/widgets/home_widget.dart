import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stripe_test/services/stripe_operations/payment_method.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Prepare the data
  String text = 'Click the button to start the payment';
  bool showSpinner = false;
  String url =
      'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';

  @override
  void initState() {
    super.initState();
    // Initialize Stripe (inside setState)
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51JQdIOLIQnmihNYkFs69YfO2pKfL9HluUGT369bvYeTObvLURt2PJdrrmhiAyy5eYmXF9VIDtXylGcuUlSWskvk100fa9PVSus',
        merchantId: 'BCR2DN6T2777DMDS',
        androidPayMode: 'test',
      ),
    );
  }

  final pm = PaymentMethodOperations();

  void runPM() {
    pm.checkIfNativePayReady(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            width: 90.0,
            child: ElevatedButton(
              onPressed: () {
                pm.checkIfNativePayReady(context);
              },
              child: Text('Pay 10\$'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 1.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(text),
        ],
      ),
    );
  }
}

class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;
  ShowDialogToDismiss(
      {required this.title, required this.buttonText, required this.content});
  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text(
              buttonText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: new Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                buttonText[0].toUpperCase() +
                    buttonText.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}
