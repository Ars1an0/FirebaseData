import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VeifyEmail extends StatefulWidget {
  const VeifyEmail({Key? key}) : super(key: key);

  @override
  _VeifyEmailState createState() => _VeifyEmailState();
}

class _VeifyEmailState extends State<VeifyEmail> {


  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    verifymail()async{
      if (user!= null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    }
    return Scaffold(
      body: Container(
        child: Center(child: Container(child: ElevatedButton(onPressed: verifymail, child: Text("Verufy Email")))),
      ),
    );
  }


}