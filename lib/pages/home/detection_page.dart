import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/button_outline_green.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:image_picker/image_picker.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

AppBar headerGreen() {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
    title: Text(
      'Panel Detection',
      style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
    ),
  );
}

class _DetectionPageState extends State<DetectionPage> {
  late int btnOnChanges;
  late String iconCamera;
  late String titleMsg;
  late int? selectedIndex = 0;

  File? _imageFile;
  String? _imgName;

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source:
              selectedIndex == 0 ? ImageSource.camera : ImageSource.gallery);

      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        _imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'failed pick image $e');
    }
  }

  Widget switchButton() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28), color: sixthColor),
      child: ToggleSwitch(
        minWidth: 90.0,
        initialLabelIndex: selectedIndex,
        cornerRadius: 20,
        activeFgColor: Colors.white,
        inactiveBgColor: sixthColor,
        inactiveFgColor: Colors.white,
        totalSwitches: 2,
        radiusStyle: true,
        customTextStyles: [
          whiteTextStyle.copyWith(fontWeight: bold),
          whiteTextStyle.copyWith(fontWeight: bold)
        ],
        labels: ['Phone', 'Esp Cam'],
        // icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
        activeBgColors: [
          [primaryColor],
          [primaryColor]
        ],
        onToggle: (index) {
          setState(() {
            selectedIndex = index;
            index == 0
                ? iconCamera = 'assets/icon_camera_phone.png'
                : iconCamera = 'assets/icon_camera_esp.png';

            index == 0
                ? titleMsg = "Connect Phone Cam"
                : titleMsg = "Connect EspCam";
          });
          Fluttertoast.showToast(msg: '$index');
        },
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              switchButton(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => _pickImage(),
            child: Container(
              width: double.infinity,
              height: 198,
              decoration: BoxDecoration(
                  color: fifthColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 6))
                  ]),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconCamera,
                      width: 82,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      titleMsg,
                      style: blackTextStyle.copyWith(
                          fontSize: 12, fontWeight: semiBold),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            height: 256,
            decoration: BoxDecoration(
                color: fifthColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 6))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageFile!,
                              height: 132,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/image_potato.png',
                            height: 132,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text('Total : 12'),
                Text('Healthy Potato : 10'),
                Text('Cursed Potato : 2'),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buttonOutlineGreen(),
              buttonGreen(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonGreen() {
    return ButtonGreen(
        title: 'Analyze',
        ontap: () {
          Fluttertoast.showToast(msg: 'Button Analyze Clicked');
        });
  }

  Widget buttonOutlineGreen() {
    return ButtonOutlineGreen(
        title: 'History',
        ontap: () {
          Fluttertoast.showToast(msg: 'Button History Clicked');
        });
  }

  void initState() {
    super.initState();

    iconCamera = 'assets/icon_camera_phone.png';

    titleMsg = "Connect Phone Cam";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [headerGreen(), body()],
      ),
    ));
  }
}
