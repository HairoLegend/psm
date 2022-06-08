// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'device.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _show = false;
  final deviceNameController = TextEditingController();
  final deviceLocationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: DevicePage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _show = true;
            setState(() {});
          },
          tooltip: 'Add Device',
          heroTag: 'uniqueTag',
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        bottomSheet: _showBottomSheet());
  }

  Widget? _showBottomSheet() {
    if (_show) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      width: 350,
                      child: TextField(
                        controller: deviceNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter device name',
                        ),
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      width: 350,
                      child: TextField(
                        controller: deviceLocationController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter device location',
                        ),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: ElevatedButton(
                        child: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.green,
                        ),
                        onPressed: () {
                          final deviceName = deviceNameController.text;
                          final deviceLocation = deviceLocationController.text;
                          final deviceDate = Timestamp.now();
                          createDevice(
                            deviceName: deviceName,
                            deviceLocation: deviceLocation,
                            deviceDate: deviceDate,
                            deviceHumidity: 0,
                            deviceLI: 0,
                            deviceMoisture: 0,
                            deviceONOFF: true,
                            deviceTemperature: 0,
                          );
                          deviceNameController.text = '';
                          deviceLocationController.text = '';
                          _show = false;
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: ElevatedButton(
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.grey,
                        ),
                        onPressed: () {
                          _show = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    } else {
      return null;
    }
  }

  Future createDevice({
    required String deviceName,
    required String deviceLocation,
    required deviceDate,
    required double deviceHumidity,
    required double deviceLI,
    required double deviceMoisture,
    required bool deviceONOFF,
    required double deviceTemperature,
  }) async {
    final docDevice = FirebaseFirestore.instance.collection('device').doc();

    final device = Device(
      id: docDevice.id,
      deviceName: deviceName,
      deviceLocation: deviceLocation,
      deviceDate: deviceDate,
      deviceHumidity: deviceHumidity,
      deviceLI: deviceLI,
      deviceMoisture: deviceMoisture,
      deviceONOFF: deviceONOFF,
      deviceTemperature: deviceTemperature,
    );
    final json = device.toJson();

    await docDevice.set(json);
  }
}

class Device {
  String id;
  final String deviceName;
  final String deviceLocation;
  final double deviceHumidity;
  final double deviceMoisture;
  final double deviceTemperature;
  final double deviceLI;
  final bool deviceONOFF;
  Timestamp deviceDate = Timestamp.now();

  Device(
      {this.id = '',
      required this.deviceName,
      required this.deviceLocation,
      required this.deviceMoisture,
      required this.deviceLI,
      required this.deviceONOFF,
      required this.deviceHumidity,
      required this.deviceTemperature,
      required this.deviceDate});

  Map<String, dynamic> toJson() => {
        'id': id,
        'deviceName': deviceName,
        'deviceLocation': deviceLocation,
        'deviceDate': deviceDate,
        'deviceHumidity': deviceHumidity,
        'deviceMoisture': deviceMoisture,
        'deviceTemperature': deviceTemperature,
        'deviceONOFF': deviceONOFF,
        'deviceLI': deviceLI,
      };

//print device list
  static Device fromJson(Map<String, dynamic> json) => Device(
        deviceName: json['deviceName'],
        deviceLocation: json['deviceLocation'],
        deviceDate: json['deviceDate'],
        deviceHumidity: json['deviceHumidity'],
        deviceLI: json['deviceLI'],
        deviceMoisture: json['deviceMoisture'],
        deviceONOFF: json['deviceONOFF'],
        deviceTemperature: json['deviceTemperature'],
      );
}
