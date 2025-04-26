import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiExample extends StatefulWidget {
  @override
  _ApiExampleState createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  String _response = "Waiting for response...";

  // Example GET request
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

    if (response.statusCode == 200) {
      setState(() {
        _response = jsonDecode(response.body)['title'];
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  // Example POST request
  Future<void> postData() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': 'Flutter',
        'body': 'API testing',
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _response = 'Created: ${jsonDecode(response.body)['id']}';
      });
    } else {
      setState(() {
        _response = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_response),
            SizedBox(height: 20),
            ElevatedButton(onPressed: fetchData, child: Text('GET Request')),
            ElevatedButton(onPressed: postData, child: Text('POST Request')),
          ],
        ),
      ),
    );
  }
}
