import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/model/createcategory.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return StreamBuilder<QuerySnapshot>(
      stream: _service.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        if(snapshot.data!.size==0){
return Text('No Categories added');
        }
        return ListView(
          shrinkWrap: true,
        children: snapshot.data!.docs.map ( (DocumentSnapshot document) {
          Map<String, dynamic> data =
          document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Text(data['catName']),

          );
        }).
        toList
        (
        )
        ,
        );
      },
    );
  }
}
