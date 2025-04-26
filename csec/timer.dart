import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeScreen(),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _totalTime = 0; // Time in seconds
  int _remainingTime = 0;
  bool _isTimerRunning = false;
  late Timer _timer;

  TextEditingController _timeController = TextEditingController();

  void _startTimer() {
    setState(() {
      _totalTime = int.tryParse(_timeController.text) ?? 0;
      _remainingTime = _totalTime;
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isTimerRunning = false;
        });
        _timer.cancel();
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _totalTime;
      _isTimerRunning = false;
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Cooking Time (in seconds):',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cooking Time',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTimerRunning ? null : _startTimer,
              child: Text('Start Timer'),
            ),
            SizedBox(height: 20),
            _isTimerRunning
                ? Column(
              children: [
                // Dynamic clock icon based on the remaining time
                Icon(
                  Icons.access_alarm,
                  size: 100,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  'Remaining Time: ${_remainingTime}s',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            )
                : Column(
              children: [
                Icon(
                  Icons.access_alarm,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  _remainingTime == 0 ? 'Time’s Up!' : 'Timer Reset',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('Reset Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
