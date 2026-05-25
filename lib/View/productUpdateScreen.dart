import 'package:firebase/ViewModel/products.dart';
import 'package:firebase/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController catagoryController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price.toString());
    descriptionController = TextEditingController(text: widget.product.Description);
    imageController = TextEditingController(text: widget.product.image);
    catagoryController = TextEditingController(text: widget.product.catagory);
    stockController = TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    catagoryController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _deleteProduct(BuildContext context, AdminViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () async {

              await vm.deleteProduct(widget.product.id);

              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to list screen
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    var vm = context.read<AdminViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Stock"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: catagoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: "Image URL"),
            ),

            const SizedBox(height: 20),

            /// IMAGE PREVIEW
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                imageController.text,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 50),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS ROW
            Row(
              children: [

                /// UPDATE BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      double price = double.tryParse(priceController.text) ?? 0;

                      var updatedProduct = ProductModel(
                        stock: int.tryParse(stockController.text) ?? 0,
                        catagory: catagoryController.text,
                        id: widget.product.id,
                        name: nameController.text,
                        image: imageController.text,
                        Description: descriptionController.text,
                        price: price,
                      );

                      vm.updateProduct(updatedProduct);

                      Navigator.pop(context);
                    },
                    child: const Text("Update"),
                  ),
                ),

                const SizedBox(width: 10),

                /// DELETE BUTTON
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      _deleteProduct(context, vm);
                    },
                    child: const Text("Delete"),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}