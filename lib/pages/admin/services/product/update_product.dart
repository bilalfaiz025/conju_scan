import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/admin/home_page.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class UpdateProductScreen extends StatefulWidget {
  final String productId;

  const UpdateProductScreen({super.key, required this.productId});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController prodName = TextEditingController();
  final TextEditingController prodPrice = TextEditingController();
  final TextEditingController prodDesp = TextEditingController();
  final TextEditingController prodLink = TextEditingController();
  final TextEditingController prodImageL = TextEditingController();

  File? _productImage;
  bool _isLoading = false;
  bool _isUrlOption = false; // Toggle between image upload or URL
  String? _productImageUrl; // To store the product image URL if provided

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  // Fetch existing product details from Firestore
  Future<void> _loadProductDetails() async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        final productData = productDoc.data() as Map<String, dynamic>;

        setState(() {
          prodName.text = productData['name'];
          prodPrice.text = productData['price'];
          prodDesp.text = productData['description'];
          prodLink.text = productData['link'];
          prodImageL.text = productData['image'] ?? '';

          // Set URL or upload option based on image URL presence
          _productImageUrl = productData['image'];
          _isUrlOption =
              _productImageUrl != null && _productImageUrl!.isNotEmpty;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
        prodImageL.clear(); // Clear URL field when uploading an image
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_productImage == null) return null;
    final ref = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child('${DateTime.now()}.jpg');
    await ref.putFile(_productImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        String? imageUrl =
            _isUrlOption ? prodImageL.text : await _uploadImageToStorage();

        await FirebaseFirestore.instance
            .collection('Products')
            .doc(widget.productId)
            .update({
          'name': prodName.text.trim(),
          'description': prodDesp.text.trim(),
          'price': prodPrice.text.trim(),
          'link': prodLink.text.trim(),
          'image': imageUrl,
        });

        Get.snackbar('Success', 'Product updated successfully');
        Get.off(const AdminHomePage()); // Navigate back to previous screen
      } catch (e) {
        Get.snackbar('Error', 'Failed to update product: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera',
                  style: TextStyle(color: Color(0xFF41BEA6))),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery',
                  style: TextStyle(color: Color(0xFF41BEA6))),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Update Product',
            style: TextStyle(
                color: Color(0xFF41BEA6), fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImageSourceBottomSheet,
                  child: _productImage != null
                      ? ClipOval(
                          child: Image.file(
                            _productImage!,
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          ),
                        )
                      : (_productImageUrl != null &&
                              _productImageUrl!.isNotEmpty)
                          ? ClipOval(
                              child: Image.network(
                                _productImageUrl!,
                                fit: BoxFit.cover,
                                height: 200,
                                width: 200,
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt,
                                  size: 40, color: AppColors.mediumAquarine),
                            ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showImageSourceBottomSheet(),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.mediumAquarine,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Change Picture"),
                ),
                const SizedBox(height: 16),
                // Product Name, Description, Price, and Link
                ..._buildTextFields(),
                const SizedBox(height: 16),

                // Update Button
                ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.mediumAquarine,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text("Update Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      _buildInputField(prodName, 'Product Name', 'Product name is required'),
      const SizedBox(height: 16),
      _buildInputField(
          prodDesp, 'Product Description', 'Product description is required',
          maxLines: 4),
      const SizedBox(height: 16),
      _buildInputField(prodPrice, 'Product Price', 'Product price is required',
          keyboardType: TextInputType.number),
      const SizedBox(height: 16),
      _buildInputField(prodLink, 'Product Link', 'Please enter a valid URL',
          validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a URL';
        const urlPattern = r'^(https?|ftp)://[^\s/$.?#].[^\s]*$';
        if (!RegExp(urlPattern).hasMatch(value)) {
          return 'Please enter a valid URL';
        }
        return null;
      }),
    ];
  }

  Widget _buildInputField(
      TextEditingController controller, String hint, String errorMessage,
      {int maxLines = 1,
      TextInputType? keyboardType,
      String? Function(String?)? validator}) {
    return CustomInputField(
      fillColor: const Color(0xFFF5FCF9),
      filled: true,
      textController: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      hintText: hint,
      maxlines: maxLines,
      keyboardType: keyboardType,
      validator: validator ??
          (value) => value == null || value.isEmpty ? errorMessage : null,
    );
  }
}
