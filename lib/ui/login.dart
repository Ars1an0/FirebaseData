import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login> {
  @override
  Widget build(BuildContext context) {


    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();


    void login()async {
      FirebaseAuth auth = FirebaseAuth.instance;


      final String email = emailcontroller.text.trim();
      final String password = passwordcontroller.text.trim();
      try{
await auth.signInWithEmailAndPassword(email: email, password: password);
print("Signed In");
      }catch(e){
        print(e);
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              TextFormField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Email'),
              ),
              TextFormField(
                controller: passwordcontroller,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your Password'),
              ),
              ElevatedButton(onPressed:login, child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
