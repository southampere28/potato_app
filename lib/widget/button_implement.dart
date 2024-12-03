import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class ButtonImplement extends StatelessWidget {
  const ButtonImplement({super.key, required this.title, required this.ontap});

  final String title;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 40,
      width: double.infinity,
      child: TextButton(
          onPressed: ontap,
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          )),
    );
  }
}
