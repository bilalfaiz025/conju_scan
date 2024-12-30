import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/admin/services/product/update_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageProductScreen extends StatelessWidget {
  const ManageProductScreen({super.key});

  // Fetch all products from Firestore
  Stream<QuerySnapshot> _fetchProducts() {
    return FirebaseFirestore.instance.collection('Products').snapshots();
  }

  // Function to delete a product
  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .delete();
      // Show success message
      Get.snackbar('Deleted', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Error deleting product: $e');
    }
  }

  // Function to edit a product
  void _editProduct(String productId) {
    Get.to(UpdateProductScreen(
      productId: productId,
    ));
  }

  // Reusable widget to display product details
  Widget _buildProductDetail(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Manage Products',
          style:
              TextStyle(color: Color(0xFF41BEA6), fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching products.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product.id;
                    final name = product['name'];
                    final description = product['description'];
                    final price = product['price'];
                    final imageUrl = product['image'] ?? '';
                    final link = product['link'];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Stack(
                            children: [
                              // Badge with product number
                              Positioned(
                                top: 0,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '#${index + 1}', // Product number (index+1)
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  // Product Image (Circular)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.image,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              )
                                            : const Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                      ),
                                      const SizedBox(height: 5),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _editProduct(productId),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Product Info Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF41BEA6),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildProductDetail(
                                            'Price:', '\$${price.toString()}'),
                                        _buildProductDetail(
                                            'Description:', description),
                                        _buildProductDetail('Link:', link),
                                      ],
                                    ),
                                  ),
                                  // Delete Button
                                  IconButton(
                                    onPressed: () => _deleteProduct(productId),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
