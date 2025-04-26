import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  int? _editingId;

  void _refreshProducts() async {
    final data = await DBHelper.getProducts();
    setState(() {
      _products = data;
    });
  }

  void _submit() async {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    if (_editingId == null) {
      await DBHelper.addProduct(name, price);
    } else {
      await DBHelper.updateProduct(_editingId!, name, price);
    }
    _nameController.clear();
    _priceController.clear();
    _editingId = null;
    _refreshProducts();
  }

  void _editProduct(Map<String, dynamic> product) {
    _nameController.text = product['name'];
    _priceController.text = product['price'].toString();
    _editingId = product['id'];
  }

  void _deleteProduct(int id) async {
    await DBHelper.deleteProduct(id);
    _refreshProducts();
  }

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping App')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Product Name')),
                TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                ElevatedButton(onPressed: _submit, child: Text(_editingId == null ? 'Add' : 'Update'))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (_, index) {
                final item = _products[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("₹${item['price']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit), onPressed: () => _editProduct(item)),
                      IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProduct(item['id'])),
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
