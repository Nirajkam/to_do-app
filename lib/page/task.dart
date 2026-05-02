import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/auth/task.dart';

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
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data here :('));
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final task = doc.data() as Map<String, dynamic>;

              return Row(
                children: [
                  ListTile(
                    title: Text(task['title'] ?? ''),
                    subtitle: Text(task['description'] ?? ''),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
