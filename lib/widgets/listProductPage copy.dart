import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_shopmall/models/products.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key}) : super(key: key);

  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  List<Products> products = <Products>[];
  //List<Products> tempProducts = <Products>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  // Future<void> readAllData() async {
  void readAllData() {
    //Products products = Products();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firebaseFirestore.collection('products');
    print('readAllData()');
    collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.docs;
      int i = 0;
      for (var snapshot in snapshots) {
        print('In for loop');
        print(snapshot.get('name'));
        print(snapshot.get('imagePath'));
        products
            .add(Products.fromMap((snapshot.data() as Map<String, dynamic>)));

        print('In products[$i].name : ${products[i].name}');
        i++;
        setState(() {
          //   products = tempProducts;
        });
      }
    });

    //setState(() {
    // products.add(Products(
    //     name: snapshot.get('name'),
    //     imagePath: snapshot.get('imagePath'),
    //     detail: snapshot.get('detail')));
    //products .add(Products.fromMap({'name': '', 'detail': '', 'imagePath': ''}));
    // products;
    //});
  }

  Widget showProductPic(int index) {
    return Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width / 2.0,
        height: MediaQuery.of(context).size.width / 2.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(
                  products[index].imagePath.toString(),
                ),
                fit: BoxFit.cover),
          ),
        ));
  }

  Widget showProductText(int index) {
    return Container(
      padding: EdgeInsets.only(right: 20),
      width: MediaQuery.of(context).size.width / 2.0,
      height: MediaQuery.of(context).size.width / 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          showProductName(index),
          showProductDetail(index),
        ],
      ),
    );
  }

  Widget showProductName(int index) {
    return Row(
      children: [
        Text(
          products[index].name.toString(),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade600),
        ),
      ],
    );
  }

  Widget showProductDetail(int index) {
    String str = products[index].detail.toString();
    if (str.length > 100) {
      str = '${str.substring(0, 99)}...';
    }
    return Text(
      str,
      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
    );
  }

  Widget showInListView(int index) {
    return Row(
      children: [
        showProductPic(index),
        showProductText(index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (itemBuilder, index) {
          return showInListView(index);

          // ListTile(
          // leading: Image.network(
          //   products[index].imagePath.toString(),
          // ),
          // title: Text(products[index].name.toString()));
        },
      ),
    );
  }
}
