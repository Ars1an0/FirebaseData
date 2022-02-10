import 'package:flutter/material.dart';

class ViewScreen extends StatelessWidget {
  final Map data;

  const ViewScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('${data['img'][1]}' 'datagdigqidggi');
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: data['img'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: NetworkImage("${data['img'][index]}"),
                    ),
                  );
                }),
          ),

          // Image(image: NetworkImage(data['img3'][1])),
          Text(data['title']),
          Text(data['subtitle']),
          Text(data['description']),
          Text(data['price']),

        ],
      ),
    ));
  }
}
