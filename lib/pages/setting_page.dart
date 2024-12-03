import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/button_implement.dart';
import 'package:potato_apps/widget/dropdown_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

String? valueDevice;
final List<String> _dropdownItemsDevice = [
  "Device 1",
  "Device 2",
];

AppBar headerGreen(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: true,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    ),
    backgroundColor: primaryColor,
    centerTitle: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
    title: Text(
      'Settings',
      style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
    ),
  );
}

Widget lottieAnimation(BuildContext context) {
  return Center(
    child: Lottie.asset(
      'assets/animations/computer_animation.json',
      height: 200,
    ),
  );
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Widget body(BuildContext context) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lottieAnimation(context),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Device & Warehouse Setting',
                      style: blackTextStyle.copyWith(
                          fontSize: 20, fontWeight: semiBold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownWidget(
                labeltxt: 'Choose Device',
                hinttxt: "(None)",
                value: valueDevice,
                onChanged: (newValue) {
                  setState(() {
                    valueDevice = newValue;
                  });
                },
                dropdownItem: _dropdownItemsDevice),
            const Spacer(),
            ButtonImplement(
                title: 'Confirm',
                ontap: () {
                  if (valueDevice == _dropdownItemsDevice[1]) {
                    AppConstant.chooseDevice = AppConstant.deviceID2;
                  } else if (valueDevice == _dropdownItemsDevice[0]) {
                    AppConstant.chooseDevice = AppConstant.deviceID;
                  } else {
                    Fluttertoast.showToast(msg: 'No Device Choosen!');
                  }

                  if (valueDevice != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                  // Fluttertoast.showToast(msg: valueDevice!);
                }),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
          appBar: headerGreen(context),
          resizeToAvoidBottomInset: true,
          body: body(context)),
    );
  }
}
