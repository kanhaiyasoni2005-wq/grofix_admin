
class ProductModel {
  String catagory;
  String id;
  String name;
  String image;
  String Description;
  int stock;
  double price;

  ProductModel({
    required this.stock,
    required this.catagory,
    required this.id,
    required this.name,
    required this.image,
    required this.Description,
    required this.price,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      catagory: map['catagory'] ?? '',
      id: id,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      Description: map['Description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "catagory": catagory,
      "name": name,
      "image": image,
      "Description": Description,
      "price": price,
      "stock": stock,
      
    };
  }
}