import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/configuration/controllers/device_controller.dart';
import 'package:potato_apps/pages/home/main_page.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/button_outline_green.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

AppBar headerGreen() {
  return AppBar(
    automaticallyImplyLeading: false,
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
  int selectedResourceImg = 0;

  // result detection
  String? resultDetect;

  File? _imageFile;
  String? _imgName;

  Future showImageResource() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedResourceImg = 0;
                            });
                            _pickImage();
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: primaryColor, width: 2)),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 30,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Camera',
                          style: primaryGreenTextStyle.copyWith(
                              fontSize: 14, fontWeight: bold),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectedResourceImg = 1;
                            });
                            await _pickImage();

                            await Future.delayed(
                                const Duration(milliseconds: 500));

                            // Check if the modal is still open before trying to close it.
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icon_gallery.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Gallery',
                          style: primaryGreenTextStyle.copyWith(
                              fontSize: 14, fontWeight: bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: selectedResourceImg == 0
              ? ImageSource.camera
              : ImageSource.gallery);

      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        _imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'failed pick image $e');
    }
  }

  Future<void> _takePhotoEsp() async {
    Fluttertoast.showToast(msg: 'Taking picture from espcam');
    final result = await DeviceController.captureImage();
    if (result != null) {
      setState(() {
        _imageFile = result;
      });
      Fluttertoast.showToast(msg: 'Gambar Berhasil ditangkap');
    } else {
      Fluttertoast.showToast(msg: 'Error, gagal menangkap gambar');
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
            onTap: () =>
                selectedIndex == 0 ? showImageResource() : _takePhotoEsp(),
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
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Image Preview'),
                                  content: Image(
                                    image: FileImage(
                                        _imageFile!), // Replace with your image URL or path
                                    fit: BoxFit.cover,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _imageFile!,
                                key: ValueKey(DateTime.now().toString()),
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/image_potato.png',
                            height: 160,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Result : ${resultDetect ?? '(None)'}',
                  style: blackTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
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
      ontap: () async {
        if (_imageFile != null) {
          Fluttertoast.showToast(msg: 'Analyzing image...');

          // Call the API to send the image and get the result
          final result =
              await DeviceController.sendImageForAnalysis(_imageFile!);

          if (result != null) {
            // Show result in a toast message or handle it in any other way
            setState(() {
              resultDetect = result['quality'];
            });
            Fluttertoast.showToast(
              msg: 'Analysis Result: ${result['quality']}',
            );
          } else {
            Fluttertoast.showToast(msg: 'Failed to analyze image.');
          }
        } else {
          Fluttertoast.showToast(msg: 'No image selected');
        }
      },
    );
  }

  Widget buttonOutlineGreen() {
    return ButtonOutlineGreen(
        title: 'Save',
        ontap: () async {
          Fluttertoast.showToast(msg: 'Saving...');

          var result = await DeviceController.saveDetectionWithImage(
              AppConstant.chooseDevice,
              resultDetect ?? '(Undetected)',
              _imageFile);

          if (result) {
            // Fluttertoast.showToast(msg: 'Success save History');
            final snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: 'Result detect was saved!',

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          } else {
            // Fluttertoast.showToast(msg: 'Failed save History');
            final snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Failed!',
                message: 'Error While Saving Result Detection!',

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
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
