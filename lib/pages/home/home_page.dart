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

  Widget panelControl() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panel Controlling',
            style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: thirdColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                      child: Text(
                    'Blower Control',
                    style: blackTextStyle.copyWith(fontWeight: bold),
                  )),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 6,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    height: 120,
                    decoration: BoxDecoration(
                      color: fifthColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode Auto',
                          style: blackTextStyle.copyWith(
                              fontWeight: medium, fontSize: 18),
                        ),
                        Text(
                          'OFF',
                          style: blackTextStyle.copyWith(
                              fontWeight: bold, fontSize: 18),
                        ),
                      ],
                    )),
              )
            ],
          )
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
          children: [header(), panelControl()],
        ),
      ),
    );
  }
}
