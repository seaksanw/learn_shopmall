import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_shopmall/myService.dart';
import 'package:learn_shopmall/widgets/listProductPage.dart';
//import 'package:path_provider/path_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  File? file;
  String? productName, productDetail;
  var url;

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker()
          .pickImage(source: imageSource, maxHeight: 800, maxWidth: 800);

      setState(() {
        file = File(object!.path);
        print('addProductPage----------------->in setState');
        print(file);
      });
    } catch (e) {}
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            label: Text('Press to Upload Data'),
            icon: Icon(Icons.upload),
            style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            onPressed: () {
              print('addProductPage--------------------->upload Pressed');
              print(
                  'addProductPage---------------------> productName: ${productName}  ,  productDetail: ${productDetail}');
              if (file == null) {
                showAlertEmptyField(
                    'Picture is empty', 'Please choose an image.');
              } else if (productName == null ||
                  productName!.isEmpty ||
                  productDetail == null ||
                  productDetail!.isEmpty) {
                showAlertEmptyField(
                    'Field is empty', 'Please, Fill Data in every field');
              } else {
                uploadPicture();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> uploadPicture() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference ref =
        firebaseStorage.ref().child('products/pic' + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file as File);
    await uploadTask.whenComplete(() async {
      url = (await ref.getDownloadURL()).toString();
      print('addProductPage------------------>picture URL = $url');
      uploadDataTofirestorage();
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (context) {
        return MyService();
      });
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }).catchError((onError) {
      print('addProductPage------------------>error upload picture ');
      print(onError);
    });
  }

  Future<void> uploadDataTofirestorage() async {
    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {
      'name': productName,
      'detail': productDetail,
      'imagePath': url,
    };
    await firebaseFirestore.collection('products').add(data).then((value) {
      print('addProductPage--------------------------->Upload data success');
    });
  }

  void showAlertEmptyField(String title, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(color: Colors.red),
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) {
          productName = value.trim();
        },
        decoration: InputDecoration(
            icon: Icon(
              Icons.local_offer,
              color: Colors.indigo.shade600,
              size: 32,
            ),
            labelText: 'Product Name',
            labelStyle: TextStyle(color: Colors.indigo.shade600),
            helperText: 'Enter new product name.',
            helperStyle: TextStyle(color: Colors.indigo.shade600)),
      ),
    );
  }

  Widget detailField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (value) {
          productDetail = value.trim();
        },
        decoration: InputDecoration(
            icon: Icon(
              Icons.details,
              color: Colors.indigo.shade600,
              size: 32,
            ),
            labelText: 'Product Detail',
            labelStyle: TextStyle(color: Colors.indigo.shade600),
            helperText: 'Enter new product detail.',
            helperStyle: TextStyle(color: Colors.indigo.shade600)),
      ),
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 42.0,
        color: Colors.blue.shade900,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget shutterButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 38.0,
        color: Colors.deepPurple,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
        print(
            'addProductPage------------------------------>shutterButton press');
      },
    );
  }

  Widget showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        shutterButton(),
        galleryButton(),
      ],
    );
  }

  Widget showPic() {
    return Container(
      //color: Colors.grey,
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null
          ? Image.asset('assets/icons/image_icon.png')
          : Image.file(file!),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          showPic(),
          showButtons(),
          nameField(),
          detailField(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          showContent(),
          uploadButton(),
        ],
      ),
    );
  }
}
