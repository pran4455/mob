import 'package:flutter/material.dart';
import '../models/products.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    List<Product> filteredProducts = demoProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("ShopEasy"),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => Navigator.pushNamed(context, '/cart'))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Image.asset(product.image, height: 120, fit: BoxFit.cover),
                      Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("\$${product.price}", style: TextStyle(color: Colors.blue)),
                      ElevatedButton(
                        onPressed: () => cart.addToCart(product),
                        child: Text("Add to Cart"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
