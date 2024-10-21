import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class LoginButton extends StatelessWidget {
  const LoginButton(
      {super.key, required this.buttonName, required this.routeFunction});

  final String buttonName;
  final VoidCallback routeFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 52,
      child: TextButton(
          onPressed: routeFunction,
          style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/google_logo.png',
                width: 26,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                buttonName,
                style:
                    blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
            ],
          )),
    );
  }
}
