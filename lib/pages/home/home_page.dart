import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: primaryColor),
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
                style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: bold),
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [header()],
        ),
      ),
    );
  }
}
