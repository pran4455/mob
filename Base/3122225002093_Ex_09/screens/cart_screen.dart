import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                var item = cart.cartItems.entries.toList()[index];
                var product = demoProducts.firstWhere((prod) => prod.id == item.key);

                return ListTile(
                  leading: Image.asset(product.image, width: 50),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price} x ${item.value}"),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () => cart.removeFromCart(product.id),
                  ),
                );
              },
            ),
          ),
          Text("Total: \$${cart.totalPrice.toStringAsFixed(2)}"),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
            child: Text("Proceed to Checkout"),
          ),
        ],
      ),
    );
  }
}
