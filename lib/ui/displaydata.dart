import 'package:firebaseintegrate/model/category_model.dart';
import 'package:firebaseintegrate/ui/displaycategory.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: FirestoreListView<Category>(
        query: categoryCollection,
        itemBuilder: (context, snapshot) {
          Category category = snapshot.data();
          return ActionChip(
              backgroundColor: _selectedCategory == category.catName
                  ? Colors.blue
                  : Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: Text(
                category.catName!,
              ),
              onPressed: () {
                setState(() {
                  _selectedCategory = category.catName;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayCategory(
                                data: _selectedCategory!,
                              )));
                });
              });
        },
      ),

    );
  }
}
