import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'db_helper.dart';

void main() {
  runApp(MaterialApp(
    home: ExpenseManager(),
    debugShowCheckedModeBanner: false,
  ));
}

class ExpenseManager extends StatefulWidget {
  @override
  State<ExpenseManager> createState() => _ExpenseManagerState();
}

class _ExpenseManagerState extends State<ExpenseManager> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  List<Map<String, dynamic>> _expenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    final data = await DBHelper.getExpenses();
    setState(() {
      _expenses = data;
    });
  }

  void _addExpense() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;
    await DBHelper.insertExpense(
      _titleController.text,
      double.parse(_amountController.text),
      DateTime.now(),
    );
    _titleController.clear();
    _amountController.clear();
    fetchExpenses();
  }

  void _deleteExpense(int id) async {
    await DBHelper.deleteExpense(id);
    fetchExpenses();
  }

  double getTotalSpent() {
    return _expenses.fold(0, (sum, item) => sum + item['amount']);
  }

  List<BarChartGroupData> getChartData() {
    final Map<String, double> dailySums = {};

    for (var expense in _expenses) {
      String date = DateFormat('MM/dd').format(DateTime.parse(expense['date']));
      dailySums[date] = (dailySums[date] ?? 0) + expense['amount'];
    }

    int i = 0;
    return dailySums.entries.map((e) {
      return BarChartGroupData(x: i++, barRods: [
        BarChartRodData(
          toY: e.value,
          color: Colors.blue,
          width: 15,
          borderRadius: BorderRadius.circular(4),
        ),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Manager'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Spent: ₹${getTotalSpent().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: getChartData(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final item = _expenses[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date']))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('₹${item['amount']}'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteExpense(item['id']),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Add'),
            onPressed: () {
              Navigator.of(context).pop();
              _addExpense();
            },
          )
        ],
      ),
    );
  }
}
