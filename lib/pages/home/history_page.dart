import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Widget deteksiKentang() {
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
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => primaryColor),
            columnSpacing: 14,
            columns: [
              DataColumn(label: Text('No.', style: whiteTextStyle)),
              DataColumn(label: Text('Normal', style: whiteTextStyle)),
              DataColumn(label: Text('Rusak', style: whiteTextStyle)),
              DataColumn(label: Text('Jumlah', style: whiteTextStyle)),
              DataColumn(label: Text('Gambar', style: whiteTextStyle)),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('1', style: whiteTextStyle)),
                DataCell(Text('50', style: whiteTextStyle)),
                DataCell(Text('5', style: whiteTextStyle)),
                DataCell(Text('55', style: whiteTextStyle)),
                DataCell(Text('Lihat', style: subtitleTextStyle)),
              ]),
              DataRow(cells: [
                DataCell(Text('2', style: whiteTextStyle)),
                DataCell(Text('45', style: whiteTextStyle)),
                DataCell(Text('10', style: whiteTextStyle)),
                DataCell(Text('55', style: whiteTextStyle)),
                DataCell(GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Image Preview'),
                          content: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/potato-base-34d80.appspot.com/o/photo%2Fapple.jpg?alt=media&token=e3eab426-a770-4d17-ba90-fdd2dd78f894', // Replace with your image URL or path
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
                    child: Text('Lihat', style: subtitleTextStyle))),
              ]),
            ],
          ),
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
          monitoringGudang('1730184375'),
          deteksiKentang()
        ],
      ),
    ));
  }
}
