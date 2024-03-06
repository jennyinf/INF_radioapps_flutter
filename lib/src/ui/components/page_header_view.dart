import 'package:flutter/material.dart';
import 'package:radioapps/flavors.dart';
import 'package:radioapps/flavors_extensions.dart';

class PageHeaderView extends StatelessWidget {
  final double logoHeight;

  const PageHeaderView({super.key, required this.logoHeight});
  
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
        
      
      
          // todo - this is a clickable link
          Text("Powered by Infonote Datasystems Ltd.",style: Theme.of(context).textTheme.labelSmall)
      
          
        ],
      ),
    );
  }

}