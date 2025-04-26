class Habit {
  final int? id;
  final String name;
  final DateTime date;
  final bool completed;

  Habit({this.id, required this.name, required this.date, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'completed': completed ? 1 : 0,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      completed: map['completed'] == 1,
    );
  }
}
