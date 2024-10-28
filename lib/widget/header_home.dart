import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 8))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang',
                style: whiteTextStyle,
              ),
              Text(
                'Ilham Islamy',
                style: whiteTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                '30 Oktober, 2024',
                style: whiteTextStyle,
              ),
            ],
          )),
          ClipOval(
              child: Image.asset(
            'assets/img_sample.jpeg',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ))
        ],
      ),
    );
  }
}
