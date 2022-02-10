import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseintegrate/firebase_service.dart';

class Category {
  Category({this.catName,});

  Category.fromJson(Map<String, Object?> json)
      : this(
    catName: json['catName']! as String,
  );

  final String? catName;

  Map<String, Object?> toJson() {
    return {
      'catName': catName,
    };
  }
}
FirebaseService _service = FirebaseService();
final categoryCollection = _service.categories.where('active', isEqualTo: true).withConverter<Category>(
  fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
  toFirestore: (movie, _) => movie.toJson(),
);