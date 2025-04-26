import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(MaterialApp(
    home: LibraryManagement(),
    debugShowCheckedModeBanner: false,
  ));
}

class LibraryManagement extends StatefulWidget {
  @override
  State<LibraryManagement> createState() => _LibraryManagementState();
}

class _LibraryManagementState extends State<LibraryManagement> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final data = await DBHelper.getBooks();
    setState(() {
      _books = data;
    });
  }

  void _addBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) return;
    await DBHelper.insertBook(_titleController.text, _authorController.text);
    _titleController.clear();
    _authorController.clear();
    fetchBooks();
  }

  void _toggleBorrow(int id, int currentStatus) async {
    await DBHelper.updateBorrowStatus(id, currentStatus == 0 ? 1 : 0);
    fetchBooks();
  }

  void _deleteBook(int id) async {
    await DBHelper.deleteBook(id);
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    int total = _books.length;
    int borrowed = _books.where((b) => b['isBorrowed'] == 1).length;
    int available = total - borrowed;

    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total: $total | Borrowed: $borrowed | Available: $available',
                  style: TextStyle(fontSize: 18)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text('By: ${book['author']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(book['isBorrowed'] == 1 ? 'Borrowed' : 'Available'),
                      IconButton(
                        icon: Icon(Icons.sync, color: Colors.blue),
                        onPressed: () => _toggleBorrow(book['id'], book['isBorrowed']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteBook(book['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Book Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
              _addBook();
            },
          )
        ],
      ),
    );
  }
}
