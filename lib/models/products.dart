class Products {
  String? name;
  String? imagePath;
  String? detail;

  Products({this.name, this.imagePath, this.detail});

  Products.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    imagePath = map['imagePath'];
    detail = map['detail'];
  }
}
