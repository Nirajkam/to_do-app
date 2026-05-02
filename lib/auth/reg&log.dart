import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registor {
  final String name;
  final String email;
  final String password;

  Registor({required this.name, required this.email, required this.password});
  Future<String> registerdb() async {
    try {
      final usercredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(usercredential.user!.uid)
          .set({'Name': name, 'Email': email, 'createdAt': DateTime.now()});
        return "Registriton Complete";
    }  on FirebaseAuthException catch (e) {
      return e.message ?? "Firebase error occurred";
    } catch (e) {
      return e.toString();
  }
}
}

class Login {
  final String email;
  final String password;
  Login({required this.email, required this.password});

  Future<String> logindb()async{
    try{
      final UserCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully Login";
    }
    on FirebaseAuthException catch(e)
    {
      return e.message ?? "Firebase error occurred";
    } catch (e) {
      return e.toString();
    }
  }
}
