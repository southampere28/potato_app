import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({super.key, required this.title, required this.assetIcon, required this.widthIcon});

  final String title;
  final String assetIcon;
  final double widthIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 3),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(assetIcon, width: widthIcon,),
          const SizedBox(width: 8,),
          Text(title, style: blackTextStyle.copyWith(fontSize: 14, fontWeight: bold),)
        ],
      ),
    );
  }
}
