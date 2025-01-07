// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/admin/home_page.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddAdSliderScreen extends StatefulWidget {
  const AddAdSliderScreen({super.key});

  @override
  State<AddAdSliderScreen> createState() => _AddAdSliderScreenState();
}

class _AddAdSliderScreenState extends State<AddAdSliderScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController sliderName = TextEditingController();
  final TextEditingController sliderPrice = TextEditingController();
  final TextEditingController sliderDesp = TextEditingController();
  final TextEditingController sliderLink = TextEditingController();
  final TextEditingController sliderImageL = TextEditingController();

  File? _sliderImage;
  bool _isLoading = false;
  bool _isUrlOption = false; // Toggle between image upload or URL

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _sliderImage = File(pickedFile.path);
        sliderImageL.clear(); // Clear URL field when uploading an image
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_sliderImage == null) return null;
    final ref = FirebaseStorage.instance
        .ref()
        .child('slider_images')
        .child('${DateTime.now()}.jpg');
    await ref.putFile(_sliderImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _addSlider() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        String? imageUrl =
            _isUrlOption ? sliderImageL.text : await _uploadImageToStorage();

        await FirebaseFirestore.instance.collection('Slider').add({
          'name': sliderName.text.trim(),
          'description': sliderDesp.text.trim(),
          'link': sliderLink.text.trim(),
          'image': imageUrl,
        });

        Get.to(const AdminHomePage());
        Get.snackbar('Success', 'Slider AD has been added successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add Slider Information: $e');
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
        title: const Text('Add AD Slider',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _isUrlOption,
                      onChanged: (value) =>
                          setState(() => _isUrlOption = false),
                    ),
                    const Text('Upload Image'),
                    const SizedBox(width: 20),
                    Radio<bool>(
                      value: true,
                      groupValue: _isUrlOption,
                      onChanged: (value) => setState(() => _isUrlOption = true),
                    ),
                    const Text('Image URL'),
                  ],
                ),
                const SizedBox(height: 16),

                // Image upload or URL input
                _isUrlOption
                    ? CustomInputField(
                        fillColor: const Color(0xFFF5FCF9),
                        filled: true,
                        textController: sliderImageL,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        hintText: "Slider Image Url",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a URL';
                          }
                          const urlPattern =
                              r'^(https?|ftp)://[^\s/$.?#].[^\s]*$';
                          if (!RegExp(urlPattern).hasMatch(value)) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      )
                    : GestureDetector(
                        onTap: _showImageSourceBottomSheet,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.mediumAquarineLite,
                          ),
                          child: _sliderImage != null
                              ? Image.file(_sliderImage!, fit: BoxFit.cover)
                              : const Center(
                                  child: Icon(Icons.camera_alt,
                                      size: 40,
                                      color: AppColors.mediumAquarine)),
                        ),
                      ),
                const SizedBox(height: 16),

                // Product Name, Description, Price, and Link
                ..._buildTextFields(),
                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: _addSlider,
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
                      : const Text("Add Slider"),
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
      _buildInputField(sliderName, 'Title', 'Enter title of AD Slider'),
      const SizedBox(height: 16),
      _buildInputField(sliderDesp, 'Sub title', 'Enter title of AD Slider',
          maxLines: 4),
      const SizedBox(height: 16),
      const SizedBox(height: 16),
      _buildInputField(
          sliderLink, 'Related Website Link', 'Please enter a valid URL',
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
