import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/header_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // thumbicon for blower controller
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

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
                  padding: const EdgeInsets.all(12),
                  height: 128,
                  decoration: BoxDecoration(
                      color: fifthColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: BlowerCard(
                    thumbIcon: thumbIcon,
                    blowerIndicator: blowerIndicator,
                    blowerValue: blowervalue,
                    onToggle: (bool value) {
                      setState(() {
                        blowervalue = value;
                        blowerIndicator = value ? "ON" : "OFF";
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 6,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    height: 128,
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
                          automateIndicator,
                          style: blackTextStyle.copyWith(
                              fontWeight: bold, fontSize: 18),
                        ),
                        Spacer(),
                        Switch(
                          thumbIcon: thumbIcon,
                          value: automateValue,
                          onChanged: (bool value) {
                            setState(() {
                              automateValue = value;
                              automateIndicator = value ? "ON" : "OFF";
                            });
                          },
                        )
                      ],
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget lightIntensityMonitor() {
    return Container(
      margin: const EdgeInsets.only(top: 18, left: 16, right: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'light intensity',
            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: primaryColor),
          )
        ],
      ),
    );
  }

  Widget temperatureHumidity() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                height: 158,
                decoration: BoxDecoration(
                    color: backgroundColor4,
                    borderRadius: BorderRadius.circular(20)),
              )),
          SizedBox(
            width: 12,
          ),
          Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                height: 158,
                decoration: BoxDecoration(
                    color: backgroundColor4,
                    borderRadius: BorderRadius.circular(20)),
              )),
        ],
      ),
    );
  }

  // blower controller variable
  late bool blowervalue;
  late String blowerIndicator;

  late bool automateValue;
  late String automateIndicator;

  // init state
  @override
  void initState() {
    super.initState();

    // blower initialize
    blowervalue = false;
    blowerIndicator = blowervalue ? "ON" : "OFF";

    // automation initialize
    automateValue = false;
    automateIndicator = automateValue ? "ON" : "OFF";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderHomeWidget(),
            panelControl(),
            lightIntensityMonitor(),
            temperatureHumidity()
          ],
        ),
      ),
    );
  }
}

class BlowerCard extends StatefulWidget {
  BlowerCard({
    super.key,
    required this.thumbIcon,
    required this.blowerValue,
    required this.blowerIndicator,
    required this.onToggle,
  });

  final MaterialStateProperty<Icon?> thumbIcon;
  final String blowerIndicator;
  final bool blowerValue;
  final ValueChanged<bool> onToggle;

  @override
  State<BlowerCard> createState() => _BlowerCardState();
}

class _BlowerCardState extends State<BlowerCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.asset(
            'assets/icon_fan.png',
            height: 36,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Blower',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                  overflow: TextOverflow.ellipsis),
              Text(widget.blowerIndicator,
                  style: blackTextStyle.copyWith(
                      fontSize: 18, fontWeight: medium)),
            ],
          )
        ]),
        Spacer(),
        Switch(
            thumbIcon: widget.thumbIcon,
            value: widget.blowerValue,
            onChanged: widget.onToggle),
      ],
    );
  }
}
