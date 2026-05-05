import 'package:flutter/material.dart';
import 'package:todo_app/auth/reg&log.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 1. Controllers
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();

  // 2. States for hiding/showing BOTH passwords
  final ValueNotifier<bool> togglePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> toggleConfirmPassword = ValueNotifier<bool>(true);

  // 3. NO MORE FocusNodes! NO MORE initState!

  @override
  void dispose() {
    // 4. Dispose EVERYTHING
    name.dispose();
    email.dispose();
    password.dispose();
    confirmpassword.dispose();
    togglePassword.dispose();
    toggleConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const image(),
              const SizedBox(height: 50),

              textfield(
                controller: name,
                hint: 'Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 10),

              textfield(controller: email, hint: 'Email', icon: Icons.email),
              const SizedBox(height: 10),

              passwords(
                controller: password,
                hint: 'Password',
                icon: Icons.password,
                toggle: togglePassword,
              ),
              const SizedBox(height: 10),

              passwords(
                controller: confirmpassword,
                hint: 'Confirm Password',
                icon: Icons.password,
                toggle: toggleConfirmPassword,
              ),
              const SizedBox(height: 10),

              sigup_button(context),
              register_button(
                Name: name,
                Email: email,
                Password: password,
                Repassword: confirmpassword,
              ),
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
          "Already have an account? ",
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    ),
  );
}

Widget register_button({
  required TextEditingController Name,
  required TextEditingController Email,
  required TextEditingController Password,
  required TextEditingController Repassword,
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
      child: GestureDetector(
        onTap: () async {
          final name = Name.text.trim();
          final email = Email.text.trim();
          final password = Password.text.trim();
          final confirmPassword = Repassword.text.trim();

          if (password != confirmPassword) {
            print("Passwords do not match!");
            return;
          }

          final reg = Registor(name: name, email: email, password: password);
          String message = await reg.registerdb();
          print(message);
        },
        child: const Text(
          'Register',
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
  required ValueNotifier<bool> toggle,
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
            image: AssetImage("assets/images/register.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
