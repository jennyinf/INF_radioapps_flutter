import 'package:flutter/material.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';
import 'package:radioapps/src/ui/components/contact_button.dart';
import 'package:radioapps/src/ui/components/widget_extensions.dart';

class PageHeaderView extends StatelessWidget {
  final double logoHeight;

  const PageHeaderView({super.key, required this.logoHeight});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          /// this animates the logo to logo height so that it can be large on the listen page 
          /// and smaller when we want to show more data
          AnimatedSize(
            // vsync: this,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child:    SizedBox(height: logoHeight,
            child:  F.appFlavor!.logo()
          ),
      
          ),
          powerText(context)      
          
        ],
      ),
    );
  }

  Widget powerText(BuildContext context) {
    final l = localisations(context);
    return ContactButton(
      type: ContactType.website,
      value: "https://www.infonote.com",
      child: Text.rich(
        TextSpan(
          text: l.pageHeaderPrefix,
          children: [
            TextSpan(
              text: l.pageHeaderSuffix,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

}