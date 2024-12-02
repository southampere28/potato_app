import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/configuration/controllers/person_controller.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/login_button.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {

    void showLoginSuccessDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 10),
                Text(
                  'Login Successful!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text('You have successfully logged in.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                ClipPath(
                  clipper: SlightCurveClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Potato Base',
                        style: primaryGreenTextStyle.copyWith(
                            fontSize: 24, fontWeight: medium),
                      ),
                      Spacer(),
                      Container(
                        height: 220,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/app_logo.png'),
                        )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Welcome Back,',
                        style: primaryGreenTextStyle.copyWith(
                            fontSize: 24, fontWeight: medium),
                      ),
                      Text(
                        'Login or Register now for continue!',
                        style: subtitleTextStyle2.copyWith(
                            fontSize: 14, fontWeight: medium),
                      ),
                      const SizedBox(
                        height: 42,
                      )
                    ],
                  ),
                )
              ]),
              const Spacer(),
              LoginButton(
                  buttonName: 'Login With Google',
                  routeFunction: () async {
                    // Fluttertoast.showToast(msg: 'Login Mahasiswa Clicked');

                    await PersonController.googleAuthLogin(context);

                    showLoginSuccessDialog(context);

                    bool success = await PersonController.updateDeviceToken(
                        AppConstant.deviceToken);
                    if (success) {
                      print('Device token updated successfully');
                    } else {
                      print('Failed to update device token');
                    }
                  }),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlightCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30); // Start at bottom-left with slight margin
    path.quadraticBezierTo(
      size.width / 2, size.height + 30, // Control point (slightly curved)
      size.width, size.height - 30, // End point
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.close(); // Complete the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
