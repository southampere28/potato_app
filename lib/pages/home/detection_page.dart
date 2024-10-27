import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/theme.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  late int? selectedIndex = 0;

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
          Container(
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
              child: Image.asset(
                iconCamera,
                width: 82,
              ),
            ),
          )
        ],
      ),
    );
  }

  void initState() {
    super.initState();

    iconCamera = 'assets/icon_camera_phone.png';
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
