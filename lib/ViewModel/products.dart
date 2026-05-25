import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/product_model.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  List<ProductModel> products = [];
  bool isLoading = true;

  /// FETCH PRODUCTS
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("User")
          .get();

      products = snapshot.docs
          .map((e) => ProductModel.fromMap(e.data(), e.id))
          .toList();

    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE PRODUCT
  Future<void> updateProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(product.id)
          .update(product.toMap());

      await fetchProducts(); // refresh

    } catch (e) {
      print('Error updating product: $e');
    }
  }

  /// 🗑️ DELETE PRODUCT (NEW ADDED)
  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(id)
          .delete();

      // refresh list after delete
      await fetchProducts();

    } catch (e) {
      print('Error deleting product: $e');
    }
  }
}