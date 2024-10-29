import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class ButtonOutlineGreen extends StatelessWidget {
  const ButtonOutlineGreen({
    super.key,
    required this.title,
    required this.ontap,
  });

  final String title;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 36,
      child: TextButton(
          onPressed: ontap,
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: primaryColor, width: 2))),
          child: Text(
            title,
            style:
                primaryGreenTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          )),
    );
  }
}

