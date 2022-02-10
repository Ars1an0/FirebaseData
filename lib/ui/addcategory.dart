import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/model/createcategory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController categorycontroller = TextEditingController();
  final FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              controller: categorycontroller,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: 'Category Name'),
            ),
            ElevatedButton(
                onPressed: () async {
                  String category = categorycontroller.text.trim();
                  service.saveCategory({
                    'catName':category,
                    'active':true
                  }).then((value) => {
                  });
                },
                child: Text("Insert")),
          ],
        ),
      ),
    );
  }
}
