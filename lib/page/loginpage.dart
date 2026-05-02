import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_app/auth/reg&log.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();

  final email = new TextEditingController();
  final password = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode1.addListener(() {
      setState(() {});
    });

    _focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              image(),
              SizedBox(height: 50),
              textfield(
                controller: email,
                focusNode: _focusNode1,
                hint: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 10),
              passwords(
                controller: password,
                focusNode: _focusNode2,
                hint: 'password',
                icon: Icons.password,
              ),
              SizedBox(height: 10),
              sigup_button(context),
              login_button(Email: email, Password: password),
            ],
          ),
        ),
      ),
    );
  }
}

Widget sigup_button(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Don't have an account",
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/registor');
          },
          child: Text(
            "Sign up",
            style: TextStyle(color: Colors.blue[700], fontSize: 14),
          ),
        ),
        SizedBox(width: 5),
      ],
    ),
  );
}

Widget login_button({
  required TextEditingController Email,
  required TextEditingController Password,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () async {
          final email = Email.text.trim();
          final password = Password.text.trim();
          final log = Login(email: email, password: password);
          String message = await log.logindb();
          print(message);
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget textfield({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hint,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffc5c5c5), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
          ),
        ),
      ),
    ),
  );
}

Widget passwords({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hint,
  required IconData icon,
}) {
  ValueNotifier<bool> toggle = ValueNotifier<bool>(true);

  return ValueListenableBuilder(
    valueListenable: toggle,
    builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            obscureText: toggle.value,

            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              suffixIcon: InkWell(
                onTap: () {
                  toggle.value = !toggle.value;
                },
                child: Icon(
                  toggle.value
                      ? Icons.visibility
                      : Icons.visibility_off_outlined,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.lightGreen,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class image extends StatelessWidget {
  const image({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
