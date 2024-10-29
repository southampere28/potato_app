import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/configuration/controller.dart';
import 'package:potato_apps/theme.dart';

class ButtonGreen extends StatelessWidget {
  const ButtonGreen({
    super.key,
    required this.title,
    required this.ontap,
  });

  final String title;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 30),
      height: 36,
      width: 100,
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
