import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/configuration/controllers/device_controller.dart';
import 'package:potato_apps/configuration/controllers/person_controller.dart';
import 'package:potato_apps/model/user_model.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/blower_card.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/header_home.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:stroke_text/stroke_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // header variable
  String fullname = "Your Name";
  String imgURL = '';

  // thumbicon for button controlling
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  // light intensity variable
  int _lightIntensity = 0;

  // temperature varable
  late String _temperature;

  // blower controller variable
  bool blowervalue = false;
  late String blowerIndicator;

  bool automateValue = false;
  late String automateIndicator;

  // Data kelembaban dengan 50% sebagai contoh
  double valueHumidity = 0;
  late List<ChartData> chartData;

  late Future<UserModel?> _userFuture;
  late Stream<Map<String, dynamic>?> _deviceStream;
  bool? deviceMode;

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
                  height: 128,
                  decoration: BoxDecoration(
                      color: fifthColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: BlowerCard(
                    thumbIcon: thumbIcon,
                    blowerIndicator: blowerIndicator,
                    blowerValue: blowervalue,
                    automate: automateValue,
                    onToggle: (bool value) {
                      setState(() {
                        blowervalue = value;
                        blowerIndicator = value ? "ON" : "OFF";
                      });
                      DeviceController.setBlowerMode(
                          AppConstant.deviceID, blowervalue);
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
                              fontWeight: medium, fontSize: 16),
                        ),
                        Text(
                          automateIndicator,
                          style: blackTextStyle.copyWith(
                              fontWeight: bold, fontSize: 16),
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
                            DeviceController.setDeviceMode(
                                AppConstant.deviceID, automateValue);
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
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                'light intensity',
                style: blackTextStyle.copyWith(fontSize: 14, fontWeight: bold),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Stack(alignment: Alignment.centerLeft, children: [
              LinearProgressIndicator(
                value: _lightIntensity / 1000, // Convert to a 0-1 range
                backgroundColor: Colors.grey[300],
                color: primaryColor,
                minHeight: 60,
                borderRadius: BorderRadius.circular(12),
              ),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StrokeText(
                      text: '${_lightIntensity}',
                      textStyle: whiteTextStyle.copyWith(
                          fontSize: 20, fontWeight: bold),
                      strokeColor: primaryColor,
                      strokeWidth: 2,
                    ),
                    StrokeText(
                      text: 'lux',
                      textStyle: whiteTextStyle.copyWith(
                          fontSize: 14, fontWeight: bold),
                      strokeColor: primaryColor,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              )
            ]),
          ],
        ));
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
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 158,
              decoration: BoxDecoration(
                  color: fifthColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 6))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature (Celcius)',
                    style: blackTextStyle.copyWith(
                        fontWeight: medium, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${_temperature}\u00B0',
                        style: primaryGreenTextStyle.copyWith(
                            fontSize: 60, fontWeight: bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              flex: 5,
              child: Container(
                  width: double.infinity,
                  height: 158,
                  decoration: BoxDecoration(
                      color: fifthColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 6))
                      ]),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial Bar Chart
                      SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            maximumValue: 100, // Maksimum 100% untuk kelembaban
                            radius: '90%', // Mengatur radius
                            innerRadius: '72%',
                            cornerStyle: CornerStyle.bothCurve,
                            trackColor: Colors.blueGrey,
                            pointColorMapper: (ChartData data, _) =>
                                Colors.orange,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: false, // Sembunyikan label default
                            ),
                          ),
                        ],
                      ),
                      // Teks di tengah lingkaran
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Humidity',
                            style: blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: medium),
                          ),
                          Text(
                              '${chartData[0].y.toInt()}%', // Menampilkan nilai kelembaban sebagai persentase
                              style: primaryGreenTextStyle.copyWith(
                                  fontSize: 28, fontWeight: bold)),
                        ],
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }

  Widget saveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonGreen(
            title: 'Save',
            ontap: () async {
              bool addWarehouse = await DeviceController.addNewWarehouseHistory(
                  '1730184375',
                  valueHumidity.toInt(),
                  _lightIntensity,
                  int.parse(_temperature));

              if (addWarehouse) {
                Fluttertoast.showToast(msg: 'success save to database');
              } else {
                Fluttertoast.showToast(msg: 'Save Failed!');
              }
            })
      ],
    );
  }

  Future<UserModel?> getUserInfo() {
    return PersonController.getUserData();
  }

  Future<bool?> getModeInfo() async {
    return await DeviceController.getDeviceMode('deviceId');
  }

  void getDeviceMode(String deviceId) async {
    deviceMode = await DeviceController.getDeviceMode(deviceId);
    setState(() {
      automateValue = deviceMode ?? false;
      automateIndicator = automateValue ? "ON" : "OFF";
    });
    print("Device mode: $deviceMode");
  }

  void getBlowerMode(String deviceId) async {
    deviceMode = await DeviceController.getBlowerMode(deviceId);
    setState(() {
      blowervalue = deviceMode ?? false;
      blowerIndicator = automateValue ? "ON" : "OFF";
    });
    print("Blower mode: $deviceMode");
  }

  // init state
  @override
  void initState() {
    super.initState();

    // automation initialize
    getDeviceMode(AppConstant.deviceID);
    print(automateValue);
    automateIndicator = automateValue ? "ON" : "OFF";

    // blower initialize
    getBlowerMode(AppConstant.deviceID);
    print(blowervalue);
    blowerIndicator = blowervalue ? "ON" : "OFF";

    _userFuture = getUserInfo(); // Memoize the future
    _deviceStream = DeviceController.streamDeviceData(
        AppConstant.deviceID); // Memoize the stream

    // light intensity initialize
    _lightIntensity = 20;

    _temperature = "0";

    chartData = [
      ChartData('Humidity', valueHumidity), // 50% humidity
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<UserModel?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data != null) {
                  String fullname = snapshot.data!.fullName;
                  String? urlPhoto = snapshot.data?.profilePhoto ?? null;
                  print('photo url : ${urlPhoto}');
                  return HeaderHomeWidget(
                      fullname: fullname, profileURL: urlPhoto ?? '');
                } else {
                  return const Center(child: Text("No data available"));
                }
              }),

          panelControl(),
          // StreamBuilder for device data
          StreamBuilder<Map<String, dynamic>?>(
            stream: _deviceStream, // Call the stream method
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                final data = snapshot.data;

                // Check if data is not null
                if (data != null) {
                  // Extract the necessary information
                  // _lightIntensity = 20;
                  _lightIntensity = data['light_intensity'];
                  _temperature = data['temperature'].toString();
                  valueHumidity = double.parse(data['humidity'].toString());
                  chartData = [ChartData('Humidity', valueHumidity)];

                  // Display or process the data as needed
                  return Column(
                    children: [
                      lightIntensityMonitor(),
                      temperatureHumidity(),
                      saveButton(),
                    ],
                  );
                } else {
                  return const Center(child: Text("No device data available"));
                }
              } else {
                return const Center(child: Text("No device data available"));
              }
            },
          ),
        ],
      ),
    ));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
