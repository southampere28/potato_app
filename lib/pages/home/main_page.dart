import 'package:flutter/material.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/pages/home/detection_page.dart';
import 'package:potato_apps/pages/home/history_page.dart';
import 'package:potato_apps/pages/home/home_page.dart';
import 'package:potato_apps/pages/home/profile_page.dart';
import 'package:potato_apps/pages/splash_screen.dart';
import 'package:potato_apps/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  // static int numberMain = 12;
  // static String chooseDevice = AppConstant.deviceID;

  @override
  State<MainPage> createState() => _MainPageState();
}

late int currentIndex;

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  Widget body() {
    switch (currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return DetectionPage();
      case 2:
        return HistoryPage();
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

  Widget menuActivated() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: primaryColor,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            unselectedItemColor: thirdColor,
            selectedItemColor: backgroundColor6,
            unselectedLabelStyle:
                subtitleTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            selectedLabelStyle: whiteTextStyle.copyWith(
                fontSize: 14, fontWeight: medium, color: Colors.white),
            items: [
              BottomNavigationBarItem(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (currentIndex == 0) menuActivated(),
                      SizedBox(
                        height: 21,
                        child: Image.asset('assets/icon_home.png',
                            width: 21,
                            color:
                                currentIndex == 0 ? Colors.white : thirdColor),
                      ),
                    ],
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (currentIndex == 1) menuActivated(),
                    SizedBox(
                      height: 21,
                      child: Image.asset('assets/icon_detect.png',
                          width: 21,
                          color: currentIndex == 1 ? Colors.white : thirdColor),
                    ),
                  ],
                ),
                label: "Detect",
              ),
              BottomNavigationBarItem(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (currentIndex == 2) menuActivated(),
                      SizedBox(
                        height: 21,
                        child: Image.asset('assets/icon_history.png',
                            width: 21,
                            color:
                                currentIndex == 2 ? Colors.white : thirdColor),
                      ),
                    ],
                  ),
                  label: "History"),
              BottomNavigationBarItem(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (currentIndex == 3) menuActivated(),
                      SizedBox(
                        height: 21,
                        child: Image.asset('assets/icon_profile.png',
                            color:
                                currentIndex == 3 ? Colors.white : thirdColor),
                      ),
                    ],
                  ),
                  label: "profile"),
            ],
          ),
        ),
        body: body(),
      ),
    );
  }
}
