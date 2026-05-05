import 'package:flutter/material.dart';
import 'package:todo_app/auth/reg&log.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Controllers
  final email = TextEditingController();
  final password = TextEditingController();

  // 2. State for hiding/showing password
  final ValueNotifier<bool> togglePassword = ValueNotifier<bool>(true);

  // 3. NO MORE FocusNodes! NO MORE initState!

  @override
  void dispose() {
    // 4. Properly dispose of everything to prevent memory leaks!
    email.dispose();
    password.dispose();
    togglePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children:[
              const SizedBox(height: 20),
              const image(),
              const SizedBox(height: 50),
              
              // No FocusNodes passed here!
              textfield(
                controller: email,
                hint: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 10),
              
              // Pass the toggle state here
              passwords(
                controller: password,
                hint: 'Password',
                icon: Icons.password,
                toggle: togglePassword,
              ),
              const SizedBox(height: 10),
              
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
      children:[
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/registor');
          },
          child: Text(
            "Sign up",
            style: TextStyle(color: Colors.blue[700], fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 5),
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
        child: const Text(
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
  required String hint,
  required IconData icon,
  required ValueNotifier<bool> toggle, // Requires the state from above!
}) {
  return ValueListenableBuilder<bool>(
    valueListenable: toggle,
    builder: (context, isObscured, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            obscureText: isObscured,
            controller: controller,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              suffixIcon: InkWell(
                onTap: () {
                  toggle.value = !toggle.value;
                },
                child: Icon(
                  isObscured ? Icons.visibility : Icons.visibility_off_outlined,
                  color: Colors.grey,
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}