// Flutter Movie Rating App
// Features: User Authentication, Movie Catalog, Rating & Review, User Profile, and more.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MovieRatingApp());
}

class MovieRatingApp extends StatelessWidget {
  const MovieRatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AuthScreen(),
    );
  }
}

// Authentication Screen
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Login with Google"),
          onPressed: () async {
            // Implement Google Sign-In
          },
        ),
      ),
    );
  }
}

// Movie Catalog Screen
class MovieCatalog extends StatelessWidget {
  const MovieCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Catalog")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var movie = snapshot.data!.docs[index];
              return ListTile(
                title: Text(movie['title']),
                subtitle: Text("Genre: " + movie['genre']),
                trailing: RatingBarIndicator(
                  rating: movie['rating'].toDouble(),
                  itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetail(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Movie Detail & Review Screen
class MovieDetail extends StatelessWidget {
  final dynamic movie;
  const MovieDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Description: ${movie['description']}", style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            child: Text("Rate & Review"),
            onPressed: () {
              // Implement Rating & Review Feature
            },
          ),
        ],
      ),
    );
  }
}

// User Profile & Watchlist
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Center(child: Text("User's Watchlist & Reviews")),
    );
  }
}
