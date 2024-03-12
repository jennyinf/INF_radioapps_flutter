

import 'package:flutter/material.dart';

class WideElevatedButton extends StatelessWidget {
  final double padding;
  final Function() onTap;
  final String title;
  final bool usePrimary;

  const WideElevatedButton({super.key,  this.padding = 0.0,
                this.usePrimary = false, 
                required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton(onPressed: onTap, 
          style: ElevatedButton.styleFrom(
                  backgroundColor: usePrimary ? Theme.of(context).colorScheme.primary : null,
                  foregroundColor: usePrimary ? Theme.of(context).colorScheme.onPrimary : null,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:  Theme.of(context).textTheme.bodyLarge,
          ),
                  child: SizedBox( width: double.infinity, 
                      child: Text(title, textAlign: TextAlign.center,))),
    );
  }



}