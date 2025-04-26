import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class DataService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<User>> fetchUsers({int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse('$apiUrl?_page=$page&_limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
