import 'package:expense_tracker_app/models/expense_models.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  final _myBox = Hive.box("expense_database");

  void saveData(List<ExpenseModels> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }

    _myBox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  List<ExpenseModels> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseModels> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseModels expense = ExpenseModels(
        name: name,
        amount: amount,
        dateTime: dateTime,
        id: '',
      );
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
