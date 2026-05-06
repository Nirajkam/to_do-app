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
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          print("0. [DEBUG] Edit button tapped!");
                          updateTaskDialog(context, doc.id, task);
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

void updateTaskDialog(
  BuildContext context,
  String docId,
  Map<String, dynamic> currentData,
) {
  print("1.[DEBUG] Edit button clicked for Task: ${currentData['title']}");

  try {
    TextEditingController taskController = TextEditingController(
      text: currentData['title']?.toString() ?? '',
    );
    TextEditingController descController = TextEditingController(
      text: currentData['description']?.toString() ?? '',
    );

    final dropdownProvider = context.read<DropdownProvider>();
    final dateProvider = context.read<date>();

    // ==========================================
    // SAFE PRIORITY PARSING (Fixes Dropdown crash)
    // ==========================================
    print("2. [DEBUG] Parsing Priority...");
    if (currentData['priority'] != null) {
      int? parsedPriority = int.tryParse(currentData['priority'].toString());

      // CHECK: Is this priority actually in our allowed list (1, 2, or 3)?
      if (parsedPriority != null &&
          dropdownProvider.options.containsValue(parsedPriority)) {
        dropdownProvider.setItem(parsedPriority);
      } else {
        dropdownProvider.clear(); // If it's an invalid number, clear it
      }
    } else {
      dropdownProvider.clear();
    }

    // ==========================================
    // SAFE DATE/TIME PARSING
    // ==========================================
    print("3. [DEBUG] Parsing Date/Time...");
    if (currentData['dateTime'] != null) {
      DateTime? existingDate;

      if (currentData['dateTime'] is Timestamp) {
        existingDate = (currentData['dateTime'] as Timestamp).toDate();
      } else if (currentData['dateTime'] is String) {
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

    print("4. [DEBUG] Data loaded safely. Opening Dialog...");

    // ==========================================
    // OPEN THE DIALOG
    // ==========================================
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
                builder: (_, provider, __) {
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
                builder: (_, provider, __) {
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
                          : "${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}",
                    ),
                  );
                },
              ),
              Consumer<date>(
                builder: (_, provider, __) {
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
            onPressed: () => Navigator.pop(dialogContext),
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

              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
    print("5. [DEBUG] Dialog requested successfully.");
  } catch (e, stacktrace) {
    print("CRASH BEFORE DIALOG OPENED: $e");
    print(stacktrace);
  }
}
