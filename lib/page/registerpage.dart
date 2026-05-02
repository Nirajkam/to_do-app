import 'package:flutter/material.dart';
import 'package:todo_app/auth/reg&log.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  FocusNode _focusNode3 = new FocusNode();
  FocusNode _focusNode4 = new FocusNode();
  ValueNotifier<bool> toggle = ValueNotifier<bool>(true);

  final name = new TextEditingController();
  final email = new TextEditingController();
  final password = new TextEditingController();
  final confirmpassword = new TextEditingController();
  @override
  void initState() {
    super.initState();

    _focusNode1.addListener(() {
      setState(() {});
    });

    _focusNode2.addListener(() {
      setState(() {});
    });

    _focusNode3.addListener(() {
      setState(() {});
    });

    _focusNode4.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmpassword.dispose();
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
              SizedBox(height: 20),
              image(),
              SizedBox(height: 50),
              textfield(
                controller: name,
                focusNode: _focusNode1,
                hint: 'Name',
                icon: Icons.supervised_user_circle_outlined,
              ),
              SizedBox(height: 10),
              textfield(
                controller: email,
                focusNode: _focusNode2,
                hint: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 10),
              passwords(
                controller: password,
                focusNode: _focusNode3,
                hint: 'password',
                icon: Icons.password,
              ),
              SizedBox(height: 10),
              passwords(
                controller: confirmpassword,
                focusNode: _focusNode4,
                hint: 'Confirm_password',
                icon: Icons.password,
              ),

              SizedBox(height: 10),
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
          "Already Have a account",
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),

        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            "login",
            style: TextStyle(color: Colors.blue[700], fontSize: 14),
          ),
        ),
        SizedBox(width: 5),
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
            image: AssetImage("assets/images/register.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
