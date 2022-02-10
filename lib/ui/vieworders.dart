import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailview.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  fetchDataFromFirebase() {
    Stream<QuerySnapshot> list =
    FirebaseFirestore.instance
        .collection('order').snapshots();
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("order screen"),),
      body:  fetchDataFromFirebase() == null
          ? CircularProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('order').snapshots(),


        initialData: null,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children:
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              return InkWell(
                onTap: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewScreen(data:data)),
                );},
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data['img'][1])),
                  title: Text(data['title']),
                  subtitle: Text(data['subtitle']),
                ),
              );
            }).toList(),
          );

        },
      ),

    );
  }
}
