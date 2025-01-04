import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/widgets/others/custom_expansion_tile.dart';
import 'package:conju_app/widgets/text_styles.dart';

import 'package:equal_space/equal_space.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.greenish,
        title: const Text("Help Center"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: SpacedColumn(
            space: MediaQuery.sizeOf(context).height * 0.01,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Common Questions are listed as following",
                style:
                    MyTextStyle.smallText(context, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomExpansionTileWidget(
                  title: Text(
                    "What is Conjunctivitis?",
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w400),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                          "Conjunctivitis, commonly known as pink eye, is the inflammation of the conjunctiva, the thin membrane covering the white part of the eye and the inner eyelids. It can be caused by infections (viral or bacterial), allergies, or irritants. Symptoms include redness, itching, swelling, and discharge."),
                    ),
                  ]),
              CustomExpansionTileWidget(
                  title: Text(
                    "Is Pink Eye termed as Conjunctivitis?",
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w400),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                          "Yes, pink eye is another term for conjunctivitis. It refers to the same condition where the conjunctiva becomes inflamed, leading to redness, itching, swelling, and sometimes discharge."),
                    )
                  ]),
              CustomExpansionTileWidget(
                  title: Text(
                    "Are these results compeletly correct?",
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w400),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                          "These results are preliminary insights and should not be relied upon as a sole diagnostic tool. Always consult a healthcare professional for confirmation and treatment."),
                    )
                  ]),
              CustomExpansionTileWidget(
                  title: Text(
                    "What are Symptoms?",
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w400),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "\u2022 Redness in the white part of the eye or inner eyelids."),
                          Text("\u2022 Itching or irritation."),
                          Text(
                              "\u2022 Watery or thick discharge, sometimes crusting around the eyes."),
                          Text("\u2022 Sensitivity to light (in some cases)."),
                          Text(
                              "\u2022 Symptoms vary based on the cause (viral, bacterial, allergic, etc.).")
                        ],
                      ),
                    )
                  ]),
              CustomExpansionTileWidget(
                  title: Text(
                    "Is there any fees?",
                    style: MyTextStyle.normalText(context,
                        fontWeight: FontWeight.w400),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                          "\u2022 This app is free to use—prioritize your health and well-being!"),
                    ),
                  ]),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri(
                    scheme: 'mailto',
                    path: 'bilalfaiz396@gmail.com',
                    query: 'subject=Help in App Inquiry&body=Hello!',
                  ));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Need more assistance")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
