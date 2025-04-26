import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: "Name")),
            TextField(decoration: InputDecoration(labelText: "Address")),
            TextField(decoration: InputDecoration(labelText: "Phone Number")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Placed!")));
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
