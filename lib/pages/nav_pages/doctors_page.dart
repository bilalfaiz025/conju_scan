import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/user/user_services.dart';
import 'package:conju_app/widgets/others/custom_tile.dart';
import 'package:conju_app/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorContactListScreen extends StatelessWidget {
  const DoctorContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.mediumAquarine,
        backgroundColor: Colors.white,
        title: const Text('Doctors list'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: FirebaseUserServices().fetchDoctors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No doctors found.'));
              } else {
                final doctors = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Near your Location",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                      ),
                      for (var doctor in doctors)
                        Stack(
                          children: [
                            CustomeTileWidget(
                              showDivider: false,
                              leading: Container(
                                height: h * 0.077,
                                width: h * 0.077,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.borderSide),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(doctor['profile_picture']),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              title: doctor['name'],
                              style: MyTextStyle.smallText(context,
                                  fontWeight: FontWeight.w500),
                              subTitle: Text(
                                doctor['address'],
                                style: MyTextStyle.smallText(
                                  context,
                                ),
                              ),
                              trailing: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    launchUrl(Uri(
                                        scheme: 'tel', path: doctor['phone']));
                                  },
                                  child: const Icon(Icons.call)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 55,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  doctor['specialization'] ?? 'General',
                                  style: MyTextStyle.miniText(context,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const Divider()
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
