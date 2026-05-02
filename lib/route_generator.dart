import 'package:flutter/material.dart';
import 'package:todo_app/auth/auth_gate.dart';
import 'package:todo_app/auth/reg&log.dart';
import 'package:todo_app/page/dashboard.dart';
import 'package:todo_app/page/home.dart';
import 'package:todo_app/page/loginpage.dart';
import 'package:todo_app/page/registerpage.dart';
import 'package:todo_app/page/task.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthGate());
      case '/registor':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());

      case '/home':
        return MaterialPageRoute(builder: (_) => Home());

      case '/task':
        return MaterialPageRoute(builder: (_) => Task());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text('Error')),
        );
      },
    );
  }
}
