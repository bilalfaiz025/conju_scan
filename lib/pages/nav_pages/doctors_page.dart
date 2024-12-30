import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/widgets/others/custom_tile.dart';
import 'package:conju_app/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorContactListScreen extends StatelessWidget {
  const DoctorContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> nameList = [
      'Carla Schoen',
      'Esther Howard',
      'Robert Fox',
      'Jacob Jones',
      'Jacob Jones',
      'Darlene Robertson',
      'Ralph Edwards',
      'Ronald Richards',
    ];
    List<String> addressList = [
      'Johar Town,Lahore',
      'Model Town,Lahore',
      'Faisal Town,Lahore',
      'Awan Town,Lahore',
      'Gulberg 1,Lahore',
      'Township,Lahore',
      'DHA Phase 2,Lahore',
      'Bahria Town,Lahore',
    ];
    var h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ophthalmologist",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                ),
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
                for (int i = 0; i < nameList.length; i++)
                  CustomeTileWidget(
                    showDivider: false,
                    leading: Container(
                      height: h * 0.057,
                      width: h * 0.057,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderSide),
                          image: const DecorationImage(
                              image: NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/024/585/326/non_2x/3d-happy-cartoon-doctor-cartoon-doctor-on-transparent-background-generative-ai-png.png',
                              ),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    title: nameList[i],
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w500),
                    subTitle: Text(addressList[i]),
                    trailing: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        launchUrl(Uri(scheme: 'tel', path: '1234567890'));
                      },
                      child: Container(
                        height: h * 0.045,
                        width: h * 0.08,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(22)),
                        child: Center(
                            child: Text(
                          'Contact',
                          style: MyTextStyle.miniText(context,
                              color: AppColors.white,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
