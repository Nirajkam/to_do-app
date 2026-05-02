import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/page/task.dart';

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
              await FirebaseAuth.instance.signOut();
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

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add new item"),
      content: Column(
        mainAxisSize: MainAxisSize
            .min, // FIX 4: Prevents the dialog from being full-screen height
        children: [
          TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: "Task Title"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: "Description"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cancel button just closes the dialog
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () async {
            // Check if title is empty before saving
            if (taskController.text.trim().isEmpty) return;

            // FIX 3: Save to Firestore ONLY when they click Submit!
            try {
              await FirebaseFirestore.instance.collection("Task").add({
                "title": taskController.text.trim(),
                "description": descController.text.trim(),
                "date": FieldValue.serverTimestamp(),
                "creator": FirebaseAuth.instance.currentUser!.uid,
                "isdone": false,
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

// I also cleaned this up for you for when you are ready to use it!
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
