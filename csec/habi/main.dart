import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';
import 'habit.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(home: HabitTrackerApp()));
}

class HabitTrackerApp extends StatefulWidget {
  @override
  State<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends State<HabitTrackerApp> {
  List<Habit> habits = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final data = await DBHelper.getHabits();
    setState(() {
      habits = data;
    });
  }

  Future<void> _addHabit(String name) async {
    final newHabit = Habit(name: name, date: DateTime.now(), completed: false);
    await DBHelper.insertHabit(newHabit);
    _controller.clear();
    _loadHabits();
  }

  Future<void> _toggleHabit(Habit habit) async {
    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      date: habit.date,
      completed: !habit.completed,
    );
    await DBHelper.updateHabit(updatedHabit);
    _loadHabits();
  }

  int calculateStreak() {
    List<Habit> completedHabits = habits.where((h) => h.completed).toList();
    completedHabits.sort((a, b) => a.date.compareTo(b.date));

    int streak = 0;
    for (int i = completedHabits.length - 1; i >= 0; i--) {
      final diff = DateTime.now().difference(completedHabits[i].date).inDays;
      if (diff == streak) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  List<BarChartGroupData> _buildBarChart() {
    final today = DateTime.now();
    List<BarChartGroupData> groups = [];

    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final count = habits.where((h) => isSameDay(h.date, day) && h.completed).length;

      groups.add(BarChartGroupData(
        x: 6 - i,
        barRods: [
          BarChartRodData(toY: count.toDouble(), color: Colors.blue),
        ],
      ));
    }
    return groups;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    int streak = calculateStreak();
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('🔥 Current Streak: $streak Days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter habit...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _addHabit(_controller.text);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text(DateFormat('MMM d, y').format(habit.date)),
                    trailing: Checkbox(
                      value: habit.completed,
                      onChanged: (_) => _toggleHabit(habit),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Weekly Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarChart(),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
