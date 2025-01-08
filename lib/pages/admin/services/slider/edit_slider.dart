import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';

class EditAdSliderScreen extends StatefulWidget {
  final String sliderId;

  const EditAdSliderScreen({super.key, required this.sliderId});

  @override
  State<EditAdSliderScreen> createState() => _EditAdSliderScreenState();
}

class _EditAdSliderScreenState extends State<EditAdSliderScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  String? _imageUrl; // Stores the existing image URL

  @override
  void initState() {
    super.initState();
    _fetchSliderDetails();
  }

  // Fetch existing slider details from Firestore
  Future<void> _fetchSliderDetails() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Slider')
          .doc(widget.sliderId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;

        nameController.text = data['name'] ?? '';
        descriptionController.text = data['description'] ?? '';
        linkController.text = data['link'] ?? '';
        _imageUrl = data['image'];
        setState(() {});
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch slider details: $e');
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_selectedImage == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('ad_sliders')
        .child('${DateTime.now()}.jpg');
    await ref.putFile(_selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveSliderDetails() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // If a new image is selected, upload it
        final imageUrl = await _uploadImageToStorage();
        await FirebaseFirestore.instance
            .collection('Slider')
            .doc(widget.sliderId)
            .update({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'link': linkController.text.trim(),
          'image': imageUrl ?? _imageUrl ?? '',
        });

        Get.snackbar('Success', 'Slider details updated successfully');
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update slider details: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(
                'Camera',
                style: TextStyle(color: Color(0xFF41BEA6)),
              ),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Color(0xFF41BEA6)),
              ),
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

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Ad Slider',
          style: TextStyle(
            color: Color(0xFF41BEA6),
            fontWeight: FontWeight.w600,
          ),
        ),
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
                // Display Slider Image
                GestureDetector(
                  onTap: () => _showImageSourceBottomSheet(context),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        )
                      : _imageUrl != null && _imageUrl!.isNotEmpty
                          ? Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: AppColors.mediumAquarine,
                              ),
                            ),
                ),
                const SizedBox(height: 16),

                // Edit Slider Image Button
                ElevatedButton(
                  onPressed: () => _showImageSourceBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: AppColors.mediumAquarine,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Edit Slider Image"),
                ),
                const SizedBox(height: 16),

                // Text Input Fields
                _buildInputField(nameController, 'Name', 'Name is required'),
                const SizedBox(height: 16),
                _buildInputField(descriptionController, 'Description',
                    'Description is required',
                    maxLines: 3),
                const SizedBox(height: 16),
                _buildInputField(linkController, 'Link', 'Link is required',
                    keyboardType: TextInputType.url),
                const SizedBox(height: 16),

                // Save Changes Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveSliderDetails,
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
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    String errorMessage, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return CustomInputField(
      fillColor: const Color(0xFFF5FCF9),
      filled: true,
      textController: controller,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      maxlines: maxLines,
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? errorMessage : null,
    );
  }
}
