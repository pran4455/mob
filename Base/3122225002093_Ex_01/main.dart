import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Enhanced App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Enhanced App")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildListTile(context, "1. Hello World App", HelloWorldScreen()),
          _buildListTile(context, "2. Simple Button Click", ButtonClickScreen()),
          _buildListTile(context, "3. Counter App", CounterScreen()),
          _buildListTile(context, "4. Column and Row Layouts", ColumnRowScreen()),
          _buildListTile(context, "5. ListView", ListViewScreen()),
          _buildListTile(context, "6. Navigation Example", FirstScreen()),
          _buildListTile(context, "7. Forms and Input", FormScreen()),
          _buildListTile(context, "8. Images and Icons", ImageIconScreen()),
          _buildListTile(context, "9. Custom Widgets", CustomWidgetScreen()),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String title, Widget screen) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
    );
  }
}

// Reusable Background Wrapper with Gradient Colors
class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

// 1. Hello World App
class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello World")),
      body: BackgroundWrapper(
        child: Center(
          child: Text(
            "Hello, World!",
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// 2. Simple Button Click
class ButtonClickScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Button Click Example")),
      body: BackgroundWrapper(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Button Clicked!", style: TextStyle(fontSize: 16))));
            },
            child: Text("Click Me", style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}

// 3. Counter App
class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter App")),
      body: BackgroundWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Counter: $counter",
                  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() => counter++);
                },
                child: Text("Increment", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. Column and Row Layouts
class ColumnRowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Column & Row Layouts")),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Column Layout", style: TextStyle(fontSize: 22, color: Colors.white)),
            Text("Title", style: TextStyle(fontSize: 18, color: Colors.white)),
            Text("Description", style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text("Row Layout", style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 5. ListView
class ListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView Example")),
      body: BackgroundWrapper(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              "Item $index",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// 6. Navigation Example
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("First Screen")),
      body: BackgroundWrapper(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondScreen()));
            },
            child: Text("Go to Second Screen", style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Screen")),
      body: BackgroundWrapper(
        child: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Back to First Screen", style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}

// 7. Forms and Input
class FormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forms and Input")),
      body: BackgroundWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your name" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your name" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your name" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Form Submitted!")));
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 8. Images and Icons
class ImageIconScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Images and Icons")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1593642634367-d91a135587b5",
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Image.network(
              "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home, size: 50, color: Colors.blue),
                Icon(Icons.star, size: 50, color: Colors.yellow),
                Icon(Icons.camera_alt, size: 50, color: Colors.green),
                Icon(Icons.favorite, size: 50, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 9. Custom Widgets
class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  CustomCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(description, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class CustomWidgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Widgets")),
      body: BackgroundWrapper(
        child: ListView(
          children: [
            CustomCard(
              title: "Peaceful Sunset",
              description: "Enjoy the tranquility of the setting sun over the ocean.",
              imageUrl: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            ),
            CustomCard(
              title: "Mountain Adventure",
              description: "Explore the majestic beauty of towering mountains.",
              imageUrl: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            ),
            CustomCard(
              title: "Leaf Serenity",
              description: "Relax in nature's calm with this serene leaf pattern.",
              imageUrl: "https://images.unsplash.com/photo-1606112219348-204d7d8b94ee",
            ),
          ],
        ),
      ),
    );
  }
}
