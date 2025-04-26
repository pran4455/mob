import 'package:flutter/material.dart';
import 'services/data_service.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> users;
  TextEditingController searchController = TextEditingController();
  List<User> filteredUsers = [];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    users = DataService().fetchUsers();
    users.then((data) {
      if (mounted) {
        setState(() => filteredUsers = data);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        loadMoreUsers();
      }
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = query.isEmpty
          ? filteredUsers
          : filteredUsers.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void loadMoreUsers() async {
    if (!isLoadingMore) {
      setState(() => isLoadingMore = true);
      try {
        List<User> newUsers = await DataService().fetchUsers(page: currentPage + 1);
        setState(() {
          currentPage++;
          filteredUsers.addAll(newUsers);
          isLoadingMore = false;
        });
      } catch (e) {
        setState(() => isLoadingMore = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Users',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) => filterUsers(query),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => setState(() {
                            users = DataService().fetchUsers(); // Retry fetching
                          }),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found.'));
                } else {
                  if (filteredUsers.isEmpty) {
                    filteredUsers = List.from(snapshot.data!);
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredUsers.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredUsers.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var user = filteredUsers[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              user.name.isNotEmpty ? user.name[0] : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(user.name, style: const TextStyle(fontSize: 18)),
                          subtitle: Text(user.email),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
