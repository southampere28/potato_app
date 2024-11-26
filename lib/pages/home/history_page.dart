import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/configuration/controllers/device_controller.dart';
import 'package:potato_apps/model/device_model.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/field_filter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
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
      'Panel History',
      style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
    ),
  );
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<WarehouseHistory>>? _historyWarehouse;
  late Future<List<DetectHistory>>? _historyDetect;

  // variable for save date information for filter
  late DateTime? selectedStartDate;
  late DateTime? selectedEndDate;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Widget selectDateFiltering() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 16, left: 16, top: 30),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.black, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search By Date',
            style: blackTextStyle.copyWith(fontSize: 14, fontWeight: bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 30,
                color: primaryColor,
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? dateTimeStart = await showDatePicker(
                      context: context,
                      initialDate: selectedStartDate ?? DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now());

                  if (dateTimeStart != null) {
                    setState(() {
                      selectedStartDate = dateTimeStart;
                    });
                  }

                  // Fluttertoast.showToast(msg: selectedStartDate.toString());
                },
                child: SizedBox(
                  height: 40,
                  width: 88,
                  child: FieldFilter(
                      controller: _startDateController,
                      icon: null,
                      keyType: TextInputType.text,
                      labelField: "Start Date",
                      hintxt: selectedStartDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedStartDate!)
                          : "set date"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '-',
                  style:
                      blackTextStyle.copyWith(fontSize: 12, fontWeight: bold),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? dateTimeEnd = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now());

                  if (dateTimeEnd != null) {
                    setState(() {
                      selectedEndDate = dateTimeEnd;
                    });
                  }

                  Fluttertoast.showToast(msg: selectedEndDate.toString());
                },
                child: SizedBox(
                  height: 40,
                  width: 88,
                  child: FieldFilter(
                      controller: _endDateController,
                      icon: null,
                      keyType: TextInputType.text,
                      labelField: "End Date",
                      hintxt: selectedEndDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedEndDate!)
                          : "set date"),
                ),
              ),
              Spacer(),
              SizedBox(
                height: 30,
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      setState(() {
                        // Trigger the filtering logic
                        _historyWarehouse =
                            DeviceController.getWarehouseHistory(
                          AppConstant.chooseDevice,
                          selectedStartDate,
                          selectedEndDate,
                        );

                        _historyDetect = DeviceController.getDetectHistory(
                            AppConstant.chooseDevice,
                            selectedStartDate,
                            selectedEndDate);
                      });
                    },
                    child: Text(
                      'set',
                      style: whiteTextStyle.copyWith(
                          fontSize: 14, fontWeight: bold),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget monitoringGudang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            'Warehouse History',
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
            future: _historyWarehouse,
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
                            '${DateFormat('dd/MM/yyyy').format(history.createdAt.toDate().toLocal())}',
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
            'History Potato Quality Detection',
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
              future: _historyDetect,
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
                          DataCell(Text(history.resultDetect,
                              style: whiteTextStyle)),
                          DataCell(Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(history.createdAt.toDate().toLocal()),
                              style: whiteTextStyle)), // Date
                          DataCell(Text(
                              history.createdAt
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .split(' ')[1]
                                  .split('.')[0],
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

  void initState() {
    super.initState();

    String deviceId = AppConstant.chooseDevice;

    selectedStartDate = null;
    selectedEndDate = DateTime.now();

    final now = DateTime.now();
    final lastWeek = now.subtract(Duration(days: 7));

    _historyWarehouse =
        DeviceController.getWarehouseHistory(deviceId, lastWeek, now);

    _historyDetect = DeviceController.getDetectHistory(deviceId, lastWeek, now);
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
          selectDateFiltering(),
          monitoringGudang(),
          deteksiKentang()
        ],
      ),
    ));
  }
}
