

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:radioapps/src/service/sponsor.dart';
import 'package:radioapps/src/ui/components/contact_button.dart';
import 'package:radioapps/src/ui/components/form/section_header.dart';
import 'package:radioapps/src/ui/extensions/color_extensions.dart';

class SponsorView extends StatefulWidget {
  final Sponsor sponsor;
  final Duration ?duration;

  const SponsorView({super.key, required this.sponsor, this.duration});

  @override
  State<SponsorView> createState() => _SponsorViewState();
}

class _SponsorViewState extends State<SponsorView> {
  @override 
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) { 

      if( widget.duration != null ) {
        Future.delayed(widget.duration!)
          .then((value) => Navigator.of(context)..pop());
      }    
    });

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        
        children: [
          ContactButton(value: widget.sponsor.website, type: ContactType.website,
          child: _view(context)),
        ],
      ),
    );
  }

  Widget _view(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _box(context, widget.sponsor.name),
         Image.network(widget.sponsor.logo, height: 220, fit: BoxFit.fill),
        _box(context, widget.sponsor.website),
      ],
    );


  }

  Color bannerColor( BuildContext context) {
    if( widget.sponsor.bannerColor == null ) {
      return Theme.of(context).colorScheme.primary;
    }
    return HexColor.fromHex(widget.sponsor.bannerColor!);
  }

  Widget _box( BuildContext context, String title ) {
    return SectionHeader(title: title, color: bannerColor(context),height: 40,);
  }
}

void showSponsorDialog(BuildContext context, Sponsor sponsor, Duration? duration) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (bc, __, ___) {
      return Theme(
        data: Theme.of(context),
        child: Center(
          
          child: Container(
            width: 400,
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias, //  add clipBehavior 
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: SizedBox.expand(child: SponsorView(sponsor: sponsor,duration: duration)),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }
  
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}