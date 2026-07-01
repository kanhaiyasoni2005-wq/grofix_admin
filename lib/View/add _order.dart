import 'package:firebase/ViewModel/orderprovider.dart';
import 'package:firebase/barcode/barcode_scanner.dart';
// import 'package:firebase/model/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../viewmodel/viewmodel.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  String selectedCategory = "vegetables";
  Future<void> scanBarcode() async {

  String? barcode =
      await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const BarcodeScreen(),
    ),
  );

  if (barcode != null) {
    productIdController.text =
        barcode;
  }
}

  List<String> categories = [
    "vegetables",
    "fruits",
    "snacks",
    "dairy",
    "hardware",
    "electronics",
    "Sell",
    "clothes",
    "beverages",
  ];
  TextEditingController productIdController =
    TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController DescController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController catagoryController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  void dispose() {
    productIdController.dispose();
    nameController.dispose();
    DescController.dispose();
    priceController.dispose();
    imageController.dispose();
    catagoryController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<Orderprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),

      body: Center(
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView( // ✅ overflow fix
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // 📝 NAME
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Product Name",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
  controller: productIdController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    hintText: "Product ID",
    suffixIcon: IconButton(
      onPressed: scanBarcode,
      icon: Icon(Icons.qr_code_scanner),
    ),
  ),
),

const SizedBox(height: 12),

                const SizedBox(height: 12),

                // 📝 DESCRIPTION
                TextField(
                  controller: DescController,
                  decoration: const InputDecoration(
                    hintText: "Description",
                  ),
                ),

                const SizedBox(height: 12),

                // 💰 PRICE
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Price",
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Stock",
                  ),
                ),

                const SizedBox(height: 12),

                // 🖼 IMAGE URL
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    hintText: "Image URL",
                  ),
                ),

                 DropdownButtonFormField<String>(
  initialValue: selectedCategory,

  items: categories.map((cat) {
    return DropdownMenuItem(
      value: cat,
      child: Text(cat),
    );
  }).toList(),

  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },

  decoration: InputDecoration(
    hintText: "Select Category",
    border: OutlineInputBorder(),
  ),
),
                const SizedBox(height: 20),

                // 🚀 BUTTON
                ElevatedButton(
                  onPressed: () async {

                    await vm.addProduct(
  productId: productIdController.text,
  catagory: selectedCategory,
  name: nameController.text,
  Description: DescController.text,
  price: priceController.text,
  image: imageController.text,
  stock: stockController.text,
);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Product Added")),
                    );

                    // Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}