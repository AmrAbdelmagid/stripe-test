const functions = require('firebase-functions');

// constant
const stripe = require('stripe')(functions.config().stripe.testkey)

// firebase function
exports.StripePI = functions.https.onRequest(async (req, res) => {


    const stripeVendorAccount = 'acct_1JQdIOLIQnmihNYk';

    // clone payment method from the clint   
    stripe.paymentMethods.create(
        {
            payment_method: req.query.paym,
        }, {
        stripeAccount: stripeVendorAccount
    },
        function (err, clonedPaymentMethod) {
            if (err !== null) {
                console.log('Error clone: ', err);
                res.send('error');
            } else {
                console.log('clonedPaymentMethod: ', clonedPaymentMethod);

                // create payment intent by the the cloned payment method 
                // here we can put the money shares of the platform and vendors       
                const fee = (req.query.amount / 100) | 0;
                stripe.paymentIntents.create(
                    {
                        amount: req.query.amount,
                        currency: req.query.currency,
                        payment_method: clonedPaymentMethod.id,
                        confirmation_method: 'automatic',
                        confirm: true,
                        application_fee_amount: fee,
                        description: req.query.description,
                    }, {
                    stripeAccount: stripeVendorAccount
                },
                    function (err, paymentIntent) {
                        // asynchronously called
                        const paymentIntentReference = paymentIntent;
                        if (err !== null) {
                            console.log('Error payment Intent: ', err);
                            res.send('error');
                        } else {
                            console.log('Created paymentintent: ', paymentIntent);
                            res.json({
                                paymentIntent: paymentIntent,
                                stripeAccount: stripeVendorAccount});
                        }
                    }
                    );
                }
            });
        });