import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/admin/services/slider/edit_slider.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageAdSlidersScreen extends StatelessWidget {
  const ManageAdSlidersScreen({super.key});

  // Fetch sliders stream
  Stream<QuerySnapshot> _fetchSliders() {
    return FirebaseFirestore.instance.collection('Slider').snapshots();
  }

  // Delete slider
  Future<void> _deleteSlider(String sliderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Slider')
          .doc(sliderId)
          .delete();
      Get.snackbar('Success', 'Ad Slider deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete Ad Slider: $e');
    }
  }

  // Slider card widget
  Widget _buildSliderCard(BuildContext context, Map<String, dynamic> sliderData,
      String sliderId, int index) {
    final imageUrl = sliderData['image'] ?? '';
    final title = sliderData['name'] ?? 'No title';
    final description = sliderData['description'] ?? 'No description';

    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: AppColors.white,
          elevation: 6,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    )
                  : const Icon(Icons.image, size: 60, color: Colors.grey),
            ),
            title: Text(
              title,
              style:
                  MyTextStyle.smallText(context, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              description,
              maxLines: 4,
              style: MyTextStyle.miniText(context),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () =>
                      Get.to(EditAdSliderScreen(sliderId: sliderId)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSlider(sliderId),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue.shade700,
            ),
            child: Center(
                child: Text(
              "#${index.toString()}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ad Sliders',
            style: TextStyle(color: Color(0xFF41BEA6))),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchSliders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading sliders'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No sliders found.'));
          }

          final sliders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: sliders.length,
            itemBuilder: (context, index) {
              final sliderData = sliders[index].data() as Map<String, dynamic>;
              final sliderId = sliders[index].id;
              return _buildSliderCard(context, sliderData, sliderId, index + 1);
            },
          );
        },
      ),
    );
  }
}
