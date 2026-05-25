import 'package:firebase/View/productUpdateScreen.dart';
import 'package:firebase/ViewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminViewModel>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<AdminViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Products")),

      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.products.isEmpty
              ? Center(child: Text("No products found"))
              : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: vm.products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                var p = vm.products[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => EditProductScreen(product: p),
                    ));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            p.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.image_not_supported),
                          ),
                        ),
                        Text(p.name),
                        Text("₹${p.price}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}