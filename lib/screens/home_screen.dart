import 'package:expense_tracker_app/components/expense_summary.dart';
import 'package:expense_tracker_app/helpers/utils.dart';

import 'package:expense_tracker_app/models/expense_models.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // Define InputDecoration for name input field
  final InputDecoration inputDecorName = InputDecoration(
    labelText: 'Name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.purple[50],
  );

  // Define InputDecoration for amount input field
  final InputDecoration inputDecorAmount = InputDecoration(
    labelText: 'Amount',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.purple[50],
  );

  void addNewExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[300],
        title: const Text("Add new expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newExpenseAmountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newExpenseAmountController.text.isNotEmpty &&
                  newExpenseNameController.text.isNotEmpty) {
                ExpenseModels newExpenseItem = ExpenseModels(
                  name: newExpenseNameController.text,
                  amount: newExpenseAmountController.text,
                  dateTime: DateTime.now(),
                  id: '',
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .addNewExpense(newExpenseItem);
                Navigator.pop(context);
                newExpenseAmountController.clear();
                newExpenseNameController.clear();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              newExpenseAmountController.clear();
              newExpenseNameController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.purple),
            ),
          )
        ],
      ),
    );
  }

  void editExpenseDialog(ExpenseModels expenseItem) {
    final TextEditingController nameController =
        TextEditingController(text: expenseItem.name);
    final TextEditingController amountController =
        TextEditingController(text: expenseItem.amount);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.grey[300],
        title: const Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: inputDecorName,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: inputDecorAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                ExpenseModels updatedExpenseItem = ExpenseModels(
                  id: expenseItem.id, // Menggunakan ID untuk identifikasi
                  name: nameController.text,
                  amount: amountController.text,
                  dateTime:
                      expenseItem.dateTime, // Menggunakan tanggal yang sama
                );

                // Memanggil metode editNewExpense dari provider
                Provider.of<ExpenseProvider>(context, listen: false)
                    .editNewExpense(updatedExpenseItem);

                Navigator.pop(context);
                nameController.clear();
                amountController.clear();
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              amountController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ExpenseProvider>(context, listen: false).preparedata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Expense Tracker"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.idCurrencyFormatter(
                          Provider.of<ExpenseProvider>(context)
                              .getTotalAmountThisWeek()
                              .toDouble()),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text("Date Range"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),
              const SizedBox(height: 50),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          extentRatio: 0.4,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              onPressed: (context) {
                                //delete expenselist
                                Provider.of<ExpenseProvider>(context,
                                        listen: false)
                                    .removeNewExpense(
                                  value.overallExpenseList[index],
                                );
                              },
                            ),
                            SlidableAction(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                onPressed: (context) {
                                  editExpenseDialog(
                                      value.getAllExpenseList()[index]);
                                }),
                          ],
                        ),
                        child: ListTile(
                          title: Text(value.getAllExpenseList()[index].name),
                          subtitle: Text(
                              '${value.getAllExpenseList()[index].dateTime.day}/${value.getAllExpenseList()[index].dateTime.month}/${value.getAllExpenseList()[index].dateTime.year}'),
                          trailing: Text(
                            Utils.idCurrencyFormatter(
                              double.parse(
                                value.getAllExpenseList()[index].amount,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              addNewExpenseDialog();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
