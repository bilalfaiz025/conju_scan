// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddAdSliderScreen extends StatefulWidget {
  const AddAdSliderScreen({super.key});

  @override
  State<AddAdSliderScreen> createState() => _AddAdSliderScreenState();
}

class _AddAdSliderScreenState extends State<AddAdSliderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _websiteLinkController = TextEditingController();
  final _imageLinkController = TextEditingController();

  File? _selectedImage;
  bool _isUsingImageLink = false;

  final ImagePicker _picker = ImagePicker();

  // Function to select an image from the device
  Future<void> _selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _isUsingImageLink = false;
      });
    }
  }

  // Function to validate and save the form
  void _saveAdSlider() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final subtitle = _subtitleController.text.trim();
      final websiteLink = _websiteLinkController.text.trim();
      final imageLink = _isUsingImageLink ? _imageLinkController.text.trim() : null;

      final image = _selectedImage ?? (_isUsingImageLink && imageLink != null
              ? imageLink
              : null);

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select or enter a background image.')),
        );
        return;
      }

      // Example:
      // AdSliderService.addAdSlider(
      //   title: title,
      //   subtitle: subtitle,
      //   backgroundImage: image,
      //   websiteLink: websiteLink,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad Slider added successfully!')),
      );

      // Clear the form after saving
      _formKey.currentState?.reset();
      setState(() {
        _selectedImage = null;
        _isUsingImageLink = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ad Slider', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Subtitle Field
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Subtitle is required' : null,
              ),
              const SizedBox(height: 16),

              // Background Image
              const Text(
                'Background Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectImage,
                      child: const Text('Select Image'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isUsingImageLink = !_isUsingImageLink;
                          _selectedImage = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isUsingImageLink ? Colors.teal : Colors.grey,
                      ),
                      child: const Text('Use Image Link'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isUsingImageLink)
                TextFormField(
                  controller: _imageLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Image Link',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Image link is required' : null,
                )
              else if (_selectedImage != null)
                Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 16),

              // Website Link
              TextFormField(
                controller: _websiteLinkController,
                decoration: const InputDecoration(
                  labelText: 'Go to Website Link',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Website link is required' : null,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAdSlider,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Save Ad Slider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
