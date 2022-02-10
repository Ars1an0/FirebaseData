import 'package:firebaseintegrate/ui/addcategory.dart';
import 'package:firebaseintegrate/ui/addproduct.dart';
import 'package:firebaseintegrate/ui/cartscreen.dart';
import 'package:firebaseintegrate/ui/displaydata.dart';
import 'package:firebaseintegrate/ui/login.dart';
import 'package:firebaseintegrate/ui/vieworders.dart';
import 'package:firebaseintegrate/ui/registerscreen.dart';
import 'package:firebaseintegrate/ui/resetscreen.dart';
import 'package:firebaseintegrate/ui/verifyemail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Button(context, Register(), 'Register'),
              Button(context, Login(), 'Login'),
            ],
          ),
          Row(
            children: [
              Button(context, ResetScreen(), 'Reset Password'),
              Button(context, VeifyEmail(), 'Verify Email'),
            ],
          ),
          Row(
            children: [
              Button(context, AddCategory(), 'Add Category'),
              Button(context, AddProduct(), 'Add Product'),
            ],
          ),
          Row(
            children: [
              Button(context, DisplayData(), 'View Categories'),
              Button(context, CartScreen(), 'View Cart'),
            ],
          ),
          Row(
            children: [
              Button(context, OrderScreen(), 'View Orders'),
            ],
          ),
        ],
      ),
    );
  }
}

Widget Button(BuildContext context, Widget ScreenName, String btnText) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenName),
          );
        },
        child: Text(btnText)),
  );
}
