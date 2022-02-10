import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/ui/vieworders.dart';
import 'package:flutter/material.dart';

import 'detailview.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  fetchDataFromFirebase() {
    Stream<QuerySnapshot> list =
    FirebaseFirestore.instance
        .collection('cart').snapshots();
    return list;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart"),
      actions: [
        IconButton(onPressed: (){_onPressed();}, icon: Icon(Icons.done_all)),
      ],),
      body:  fetchDataFromFirebase() == null
          ? CircularProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart').snapshots(),


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
                  trailing: IconButton(onPressed: (){
                     FirebaseFirestore.instance.collection('cart').doc(document.id).delete().then((value) {
                       print('Success');
                     });

                  },icon: Icon(Icons.close),),
                ),
              );
            }).toList(),
          );

        },
      ),

    );

  }
  void _onPressed()async {
    FirebaseFirestore.instance.collection("cart").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        FirebaseFirestore.instance
            .collection('order')
            .doc()
            .set(result.data());
      });
    });
    batchDelete();
  }




  CollectionReference users = FirebaseFirestore.instance.collection('cart');

  Future<void> batchDelete() {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    return users.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }
}
