import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/Dropdown_provider.dart';
import 'package:todo_app/provider/time&date.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Task")
            .where('creator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('dateTime', descending: false) // Sorting by date!
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Server Error:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data here :('));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final task = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task['description'] ?? ''),
                      const SizedBox(height: 5),

                      // Display Priority
                      if (task['priority'] != null)
                        Text(
                          'Priority: ${task['priority']}',
                          style: TextStyle(color: Colors.blue),
                        ),

                      // Display Date and Time (Handling Firestore Timestamp)
                      if (task['dateTime'] != null)
                        Text(
                          'Due: ${(task['dateTime'] as Timestamp).toDate().toString().split('.')[0]}',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.update, color: Colors.blue),
                        onPressed: () {
                          IconButton(
                            icon: const Icon(Icons.update, color: Colors.blue),
                            onPressed: () {
                              UpdateTask(context, doc.id, task);
                            },
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Task")
                              .doc(doc.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void UpdateTask(
  BuildContext context,
  String docId,
  Map<String, dynamic> currentData,
) {
  try {
    // 1. Pre-fill text fields safely
    TextEditingController taskController = TextEditingController(
      text: currentData['title']?.toString() ?? '',
    );
    TextEditingController descController = TextEditingController(
      text: currentData['description']?.toString() ?? '',
    );

    final dropdownProvider = context.read<DropdownProvider>();
    final dateProvider = context.read<date>();

    // 2. Safely parse priority
    if (currentData['priority'] != null) {
      int? parsedPriority = int.tryParse(currentData['priority'].toString());
      if (parsedPriority != null) {
        dropdownProvider.setItem(parsedPriority);
      }
    } else {
      dropdownProvider.clear();
    }

    // 3. Safely parse Date and Time
    if (currentData['dateTime'] != null) {
      DateTime? existingDate;

      // Check if it's a Firestore Timestamp
      if (currentData['dateTime'] is Timestamp) {
        existingDate = (currentData['dateTime'] as Timestamp).toDate();
      }
      // Fallback if it somehow saved as a String
      else if (currentData['dateTime'] is String) {
        existingDate = DateTime.tryParse(currentData['dateTime']);
      }

      if (existingDate != null) {
        dateProvider.setDate(existingDate);
        dateProvider.setTime(TimeOfDay.fromDateTime(existingDate));
      } else {
        dateProvider.clear();
      }
    } else {
      dateProvider.clear();
    }

    // 4. Open the Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Task"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(hintText: "Task Title"),
              ),
              const SizedBox(height: 10),
              Consumer<DropdownProvider>(
                builder: (context, provider, child) {
                  return DropdownButton<int>(
                    hint: const Text('Select priority'),
                    value: provider.selectedValue,
                    items: provider.options.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) provider.setItem(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              Consumer<date>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: provider.selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) provider.setDate(picked);
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
                        initialTime: provider.selectedTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) provider.setTime(picked);
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              final taskDateTime = dateProvider.combinedDateTime;
              if (taskController.text.trim().isEmpty) return;

              try {
                await FirebaseFirestore.instance
                    .collection("Task")
                    .doc(docId)
                    .update({
                      "title": taskController.text.trim(),
                      "description": descController.text.trim(),
                      'dateTime': taskDateTime,
                      "priority": dropdownProvider.selectedValue,
                    });
              } catch (e) {
                print("Error updating task: $e");
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  } catch (e) {
    print("CRASH BEFORE DIALOG OPENED: $e");
  }
}
