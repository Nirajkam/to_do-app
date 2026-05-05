import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/page/task.dart';
import 'package:todo_app/provider/Dropdown_provider.dart';
import 'package:todo_app/provider/time&date.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const Center(
      child: Text("Welcome to Todo App!", style: TextStyle(fontSize: 24)),
    ),
    const Task(),
  ];

  void _navigate(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (builder) => AlertDialog(
                  title: Text("Do you want to logout"),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: Text("Ok", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      body: pages[selectedIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          openTask(context);
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _navigate,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
        ],
      ),
    );
  }
}

void openTask(BuildContext context) {
  TextEditingController taskController = TextEditingController();

  TextEditingController descController = TextEditingController();

  context.read<DropdownProvider>().clear();
  context.read<date>().clear();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add new item"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize
              .max, // FIX 4: Prevents the dialog from being full-screen height
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(hintText: "Task Title"),
            ),
            const SizedBox(height: 10),
            Consumer<DropdownProvider>(
              builder: (context, provider, child) {
                return DropdownButton<int>(
                  hint: Text('Select priority'),
                  value: provider.selectedValue,
                  items: provider.options.entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.value, // 1,2,3
                      child: Text(entry.key), // label
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setItem(value);
                    }
                  },
                );
              },
            ),
            SizedBox(height: 30),
            Consumer<date>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      provider.setDate(picked);
                    }
                  },
                  child: Text(
                    provider.selectedDate == null
                        ? "Select Date"
                        : provider.selectedDate!.toString().split(" ")[0],
                  ),
                );
              },
            ),
            Consumer<date>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (picked != null) {
                      provider.setTime(picked);
                    }
                  },
                  child: Text(
                    provider.selectedTime == null
                        ? "Select Time"
                        : provider.selectedTime!.format(context),
                  ),
                );
              },
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () async {
            final provider = context.read<DropdownProvider>();
            final dateTimeProvider = context.read<date>();

            final taskDateTime = dateTimeProvider.combinedDateTime;
            if (taskController.text.trim().isEmpty) return;

            try {
              await FirebaseFirestore.instance.collection("Task").add({
                "title": taskController.text.trim(),
                "description": descController.text.trim(),
                "date": FieldValue.serverTimestamp(),
                "creator": FirebaseAuth.instance.currentUser!.uid,
                'dateTime': taskDateTime,
                "isdone": false,
                "priority": provider.selectedValue,
              });
            } on FirebaseException catch (e) {
              print(e.message);
            }

            // Close the dialog box after saving successfully
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}

void deletetask(BuildContext context, String taskId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("This task will be deleted permanently."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            // Delete logic using the document ID
            await FirebaseFirestore.instance
                .collection("Task")
                .doc(taskId)
                .delete();
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
