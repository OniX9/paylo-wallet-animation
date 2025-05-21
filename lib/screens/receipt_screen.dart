import 'package:flutter/material.dart';
import 'package:paylo_wallet_animation/widgets/custom_button.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Transaction Success',
            style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14,
                fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blueGrey[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: "receipt",
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Image.asset("assets/receipt.png"),
              ),
            ),
            
            CustomButton(onPressed: Navigator.of(context).pop, title: "Done", backgroundColor: Colors.green)
          ],
        ),
      ),
    );
  }
}
