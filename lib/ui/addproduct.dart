import 'dart:io';

import 'package:firebaseintegrate/model/createcategory.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  getCategories() {
    _service.categories.get().then((value) => {
          value.docs.forEach((element) {
            setState(() {
              _categories.add(element['catName']);
            });
          })
        });
  }

  Widget _categoryDropDown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: Text('Select Category'),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        return 'Select Category';
      },
    );
  }

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController subtitlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  FirebaseService _service = FirebaseService();
  final List<String> _categories = [];
  String? selectedCategory;
  Object? _selectedValue;

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  int uploadItem = 0;
  bool isUploading = false;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    label: Text('Enter Title'),
                  )
              ),
              TextFormField(
                controller: subtitlecontroller,
                decoration: InputDecoration(
                  label: Text('Enter SubTitle'),
                )
              ),
              TextFormField(
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                    label: Text('Enter Description'),
                  )
              ),

              ElevatedButton(
                  onPressed: () async {
                    selectImage();
                  },
                  child: Text("Select Images")),
              ElevatedButton(
                  onPressed: () async {
                    if (selectedFiles.length <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please Select Images'),
                      ));
                    } else {

                      uploadFunction(selectedFiles);
                    }
                  },
                  child: Text("Submit Post")),
              Wrap(
                children: selectedFiles
                    .map((e) => Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(e.path),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedFiles.remove(e);
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  size: 15,
                                  color: Colors.red,
                                )),
                          ],
                        ))
                    .toList(),
              ),
              Container(
                child: isUploading ? CircularProgressIndicator() : SizedBox(),
              ),

              _categoryDropDown()
            ],
          ),
        ),
      ),
    );
  }

  void uploadFunction(List<XFile> images) async {
    FirebaseService _service = FirebaseService();
    setState(() {
      isUploading = true;
    });
    List<String> arrImageUrls = [];
    for (int i = 0; i < images.length; i++) {
      var imageUrl = await uploadFile(images[i]);
      arrImageUrls.add(imageUrl.toString());
    }
    String title = titlecontroller.text;
    String subtitle = subtitlecontroller.text;
    String description = descriptioncontroller.text;
    String price = pricecontroller.text;
    FirebaseFirestore db = FirebaseFirestore.instance;
    await _service.categories.doc(selectedCategory).collection(selectedCategory!).add({
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "price": price,
      "img": arrImageUrls,
    });

    setState(() {
      selectedFiles.clear();
      isUploading = false;
    });
  }

  Future<String> uploadFile(XFile _image) async {
    Reference reference = _storageRef.ref().child(_image.name);
    File file = File(_image.path);
    await reference.putFile(file);
    String downloadUrl = await reference.getDownloadURL();
    print('$downloadUrl');
    return downloadUrl;
  }

  Future<void> selectImage() async {
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        selectedFiles.addAll(imgs);
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }


}
