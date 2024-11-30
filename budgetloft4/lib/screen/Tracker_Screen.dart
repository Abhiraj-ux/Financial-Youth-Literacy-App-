import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BUDGET LOFT',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: ExpenseTrackerPage(),
    );
  }
}

class ExpenseTrackerPage extends StatefulWidget {
  @override
  _ExpenseTrackerPageState createState() => _ExpenseTrackerPageState();
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  final List<Map<String, dynamic>> _expenses = [];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  double _income = 0.0;
  double _budget = 0.0;

  void _addExpense() {
    final String description = _descriptionController.text;
    final String amountText = _amountController.text;

    if (description.isNotEmpty && amountText.isNotEmpty) {
      final double? amount = double.tryParse(amountText);
      if (amount != null) {
        setState(() {
          _expenses.add({
            'description': description,
            'amount': amount,
            'date': DateTime.now(),
          });
        });
        _descriptionController.clear();
        _amountController.clear();
      } else {
        _showErrorDialog("Invalid amount.");
      }
    } else {
      _showErrorDialog("Description and amount can't be empty.");
    }
  }

  void _setIncomeAndBudget() {
    final incomeText = _incomeController.text;
    final budgetText = _budgetController.text;

    final double? income = double.tryParse(incomeText);
    final double? budget = double.tryParse(budgetText);

    if (income != null && income > 0 && budget != null && budget > 0) {
      setState(() {
        _income = income;
        _budget = budget;
      });
      _incomeController.clear();
      _budgetController.clear();
    } else {
      _showErrorDialog(
          "Please enter valid income and budget values greater than zero.");
    }
  }

  double _calculateTotalExpenses() {
    return _expenses.fold(0.0, (sum, item) => sum + item['amount']);
  }

  double _calculateRemainingBalance() {
    if (_budget <= 0) {
      return 0.0;
    }

    double remainingBalance = _budget - _calculateTotalExpenses();
    return remainingBalance;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoBlock(
                  "Available Balance", _calculateRemainingBalance()),
              SizedBox(height: 20),
              Text(
                "Set Income and Budget",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _incomeController,
                      decoration: InputDecoration(labelText: "Monthly Income"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      decoration: InputDecoration(labelText: "Monthly Budget"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _setIncomeAndBudget,
                child: Text("Set Income & Budget"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBlock("Income", _income),
                  _buildInfoBlock("Expenses", _calculateTotalExpenses()),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                "Add New Expense",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addExpense,
                child: Text("Add Expense"),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return Card(
                    child: ListTile(
                      title: Text(expense['description']),
                      subtitle: Text(
                          "${expense['date'].toLocal().toString().split(' ')[0]}"),
                      trailing: Text(
                        "₹${expense['amount'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(String title, double value) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              color: title == "Available Balance" && value < 0
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}