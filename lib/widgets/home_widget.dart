import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60.0,
            width: 90.0,
            child: ElevatedButton(
              onPressed: () {},
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
          Text('Click the button to start the payment'),
        ],
      ),
    );
  }
}
