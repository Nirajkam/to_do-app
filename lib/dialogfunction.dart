import 'package:flutter/material.dart';

Future<String?> openTask(BuildContext context) async {
  TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add new item"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Enter task"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}