// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController doctorName = TextEditingController();
  final TextEditingController doctorEmail = TextEditingController();
  final TextEditingController doctorPhone = TextEditingController();
  final TextEditingController doctorAddress = TextEditingController();
  final TextEditingController doctorSpecialization = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_profileImage == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('doctor_profiles')
        .child('${DateTime.now()}.jpg');
    await ref.putFile(_profileImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _addDoctor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final imageUrl = await _uploadImageToStorage();
        await FirebaseFirestore.instance.collection('Doctors').add({
          'name': doctorName.text.trim(),
          'email': doctorEmail.text.trim(),
          'phone': doctorPhone.text.trim(),
          'address': doctorAddress.text.trim(),
          'specialization': doctorSpecialization.text.trim(),
          'profile_picture': imageUrl,
        });

        Get.snackbar('Success', 'Doctor added successfully');
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar('Error', 'Failed to add doctor: $e');
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
        title: const Text('Add Doctor',
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
                GestureDetector(
                  onTap: () => _showImageSourceBottomSheet(context),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.mediumAquarineLite,
                    ),
                    child: _profileImage != null
                        ? Image.file(_profileImage!, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.camera_alt,
                                size: 40, color: AppColors.mediumAquarine),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildTextFields(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addDoctor,
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
                      : const Text("Add Doctor"),
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
      _buildInputField(doctorName, 'Doctor Name', 'Doctor name is required'),
      const SizedBox(height: 16),
      _buildInputField(doctorEmail, 'Doctor Email', 'Valid email is required',
          keyboardType: TextInputType.emailAddress, validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
        if (!RegExp(emailPattern).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      }),
      const SizedBox(height: 16),
      _buildInputField(doctorPhone, 'Doctor Phone', 'Phone number is required',
          keyboardType: TextInputType.phone),
      const SizedBox(height: 16),
      _buildInputField(
        doctorSpecialization,
        'Specialization',
        'Specialization field is required',
      ),
      const SizedBox(height: 16),
      _buildInputField(doctorAddress, 'Doctor Address', 'Address is required',
          maxLines: 3),
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
