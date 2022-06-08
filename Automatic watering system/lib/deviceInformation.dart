// ignore_for_file: prefer_const_constructor, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/dashboard.dart';
import 'package:hehe/deviceHistory.dart';
import 'package:hehe/schedule.dart';

class DeviceInformation extends StatefulWidget {
  final String deviceID;
  const DeviceInformation({Key? key, required this.deviceID}) : super(key: key);
  @override
  State<DeviceInformation> createState() => _DeviceInformationState();
}

class _DeviceInformationState extends State<DeviceInformation> {
  final deviceNameControl = TextEditingController();
  final deviceLocationControl = TextEditingController();
  bool isLoading = true;
  String? deviceID;

  void updateSwitch(bool newSwitch) async {
    await FirebaseFirestore.instance
        .collection('device')
        .doc(deviceID)
        .update({'deviceONOFF': newSwitch});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    deviceNameControl.dispose();
    deviceLocationControl.dispose();

    super.dispose();
  }

  @override
  void initState() {
    deviceID = widget.deviceID;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFf7be7c);
    return isLoading == true
        ? CircularProgressIndicator()
        : WillPopScope(
            onWillPop: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
              return Future(() => false);
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Device Information',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: primaryColor,
                ),
                body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('device')
                        .doc(deviceID)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      DocumentSnapshot? doc = snapshot.data;
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());

                      bool switchValue = doc!['deviceONOFF'];
                      return SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 350,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: doc['deviceName'],
                                        hintText: 'Change device name'),
                                    controller: deviceNameControl,
                                  ),
                                ),
                                SizedBox(
                                  width: 350,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        // Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
                                        labelText: doc['deviceLocation'],
                                        hintText: 'Change device location'),
                                    controller: deviceLocationControl,
                                  ),
                                ),
                                SwitchListTile(
                                  title: const Text('On/Off Device'),
                                  value: switchValue,
                                  onChanged: (bool newSwitch) {
                                    setState(() {
                                      switchValue = newSwitch;
                                      updateSwitch(newSwitch);
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Temperature :',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        doc['deviceTemperature'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Humidity :',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        doc['deviceHumidity'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Light Intensity :',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        doc['deviceLI'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Soil Moisture :',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        doc['deviceMoisture'].toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceSchedule(
                                                      devID:
                                                          deviceID as String)),
                                        );
                                      },
                                      child: const Text('View Schedule'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DeviceHistory(
                                                        devID: deviceID
                                                            as String)),
                                          );
                                        },
                                        child: const Text('View History'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        final deviceName =
                                            deviceNameControl.text;
                                        final deviceLocation =
                                            deviceLocationControl.text;
                                        final updateDevice = FirebaseFirestore
                                            .instance
                                            .collection('device')
                                            .doc(doc.id);
                                        updateDevice.update({
                                          'deviceName': deviceName,
                                          'deviceLocation': deviceLocation
                                        });
                                      },
                                      child: const Text('Save Change'),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    })),
          );
    //
  }
}
