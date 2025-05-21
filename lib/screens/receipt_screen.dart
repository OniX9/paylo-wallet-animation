import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Money',
            style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Hero(
          tag: "receipt",
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Image.asset("assets/receipt.png"),
          ),
        ),
      ),
    );
  }
}
