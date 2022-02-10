import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/ui/cartscreen.dart';
import 'package:flutter/material.dart';

import 'detailview.dart';

class DisplayCategory extends StatefulWidget {
  final String data;

  DisplayCategory({Key? key, required this.data}) : super(key: key);

  @override
  State<DisplayCategory> createState() => _DisplayCategoryState();
}

class _DisplayCategoryState extends State<DisplayCategory> {
  fetchDataFromFirebase(String categoryName) {
    Stream<QuerySnapshot> list = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryName)
        .collection(categoryName)
        .snapshots();
    return list;
  }

  int itemsInCart = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              icon: Stack(
                // fit: StackFit.expand,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  itemsInCart == 0
                      ? SizedBox()
                      : CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 7,
                          child: Text(
                            '$itemsInCart',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ))
                ],
              ))
        ],
      ),
      body: fetchDataFromFirebase(widget.data) == null
          ? CircularProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(widget.data)
                  .collection(widget.data)
                  .snapshots(),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewScreen(data: data)),
                        );
                      },
                      child: ListTile(
                          leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(data['img'][1])),
                          title: Text(data['title']),
                          subtitle: Text(data['subtitle']),
                          trailing: IconButton(
                            icon: Icon(Icons.shopping_cart),
                            onPressed: () async {
                              final snapShot = await FirebaseFirestore.instance
                                  .collection('cart')
                                  .doc(document.id)
                                  .get();

                              if (snapShot.exists) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Already Exsits'),
                                  ),
                                );
                              } else {
                                FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(document.id)
                                    .set(data);
                                setState(() {
                                  itemsInCart++;
                                });
                              }
                            },
                          )),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
