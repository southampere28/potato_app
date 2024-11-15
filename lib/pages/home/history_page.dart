import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/configuration/controllers/device_controller.dart';
import 'package:potato_apps/model/device_model.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

AppBar headerGreen() {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
    title: Text(
      'Panel History',
      style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
    ),
  );
}

class _HistoryPageState extends State<HistoryPage> {
  Widget monitoringGudang(String deviceId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            'History Monitoring Gudang',
            style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryColor,
          ),
          child: FutureBuilder<List<WarehouseHistory>>(
            future: DeviceController.getWarehouseHistory(deviceId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No warehouse history found.'));
              }

              // Display the fetched warehouse history
              final historyList = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => primaryColor),
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text('No', style: whiteTextStyle)),
                    DataColumn(label: Text('Temp', style: whiteTextStyle)),
                    DataColumn(label: Text('Humid', style: whiteTextStyle)),
                    DataColumn(label: Text('Lux', style: whiteTextStyle)),
                    DataColumn(label: Text('Date', style: whiteTextStyle)),
                    DataColumn(label: Text('Time', style: whiteTextStyle)),
                  ],
                  rows: List<DataRow>.generate(
                    historyList.length,
                    (index) {
                      final history = historyList[index];
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}', style: whiteTextStyle)),
                        DataCell(Text('${history.temperature}°C',
                            style: whiteTextStyle)),
                        DataCell(Text('${history.humidity}%',
                            style: whiteTextStyle)),
                        DataCell(Text('${history.lightIntensity} lx',
                            style: whiteTextStyle)),
                        DataCell(Text(
                            '${history.createdAt.toDate().toLocal().toString().split(' ')[0]}',
                            style: whiteTextStyle)), // Date
                        DataCell(Text(
                            '${history.createdAt.toDate().toLocal().toString().split(' ')[1].split('.')[0]}',
                            style: whiteTextStyle)), // Time
                      ]);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget deteksiKentang(String deviceId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Text(
            'History Deteksi Kentang',
            style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: primaryColor,
          ),
          child: FutureBuilder<List<DetectHistory>>(
              future: DeviceController.getDetectHistory(deviceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Detect history found.'));
                }

                // Display the fetched detect history
                final historyList = snapshot.data!;
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => primaryColor),
                    columnSpacing: 14,
                    columns: [
                      DataColumn(label: Text('No', style: whiteTextStyle)),
                      DataColumn(label: Text('Hasil', style: whiteTextStyle)),
                      DataColumn(label: Text('Date', style: whiteTextStyle)),
                      DataColumn(label: Text('Time', style: whiteTextStyle)),
                      DataColumn(
                          label: Text(
                        'Gambar',
                        style: whiteTextStyle,
                      ))
                    ],
                    rows: List<DataRow>.generate(
                      historyList.length,
                      (index) {
                        final history = historyList[index];
                        return DataRow(cells: [
                          DataCell(Text('${index + 1}', style: whiteTextStyle)),
                          DataCell(Text('${history.resultDetect}',
                              style: whiteTextStyle)),
                          DataCell(Text(
                              '${history.createdAt.toDate().toLocal().toString().split(' ')[0]}',
                              style: whiteTextStyle)), // Date
                          DataCell(Text(
                              '${history.createdAt.toDate().toLocal().toString().split(' ')[1].split('.')[0]}',
                              style: whiteTextStyle)), // Time
                          DataCell(GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Image Preview'),
                                    content: Image.network(
                                      history
                                          .imageDetect, // Replace with your image URL or path
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Cannot load image/image not found",
                                                  style:
                                                      alertTextStyle.copyWith(
                                                          fontSize: 16,
                                                          fontWeight: bold),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                              child: Text('Lihat', style: subtitleTextStyle))),
                        ]);
                      },
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerGreen(),
          monitoringGudang(AppConstant.deviceID),
          deteksiKentang(AppConstant.deviceID)
        ],
      ),
    ));
  }
}
