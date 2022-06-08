// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/deviceHistory.dart';

class SessionHistory extends StatefulWidget {
  final String historyID;
  final String deviceID;

  const SessionHistory(
      {Key? key, required this.historyID, required this.deviceID})
      : super(key: key);

  @override
  State<SessionHistory> createState() => _SessionHistory();
}

class _SessionHistory extends State<SessionHistory> {
  bool isLoading = true;
  String? historyID;
  String? deviceID;

  void initState() {
    deviceID = widget.deviceID;
    historyID = widget.historyID;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldpop = true;
    const primaryColor = Color(0xFFf7be7c);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeviceHistory(devID: deviceID as String)));

        // context, MaterialPageRoute(builder: (context) => DeviceHistory()));
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Session History',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: primaryColor,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('history')
                .doc(historyID)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              DocumentSnapshot doc = snapshot.data!;
              DateTime printSessionDate = doc['sessionDate'].toDate();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Date Time : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '$printSessionDate',
                          // doc!['sessionDate'].toString(),
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
                          'Temperature : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          doc['sessionTemperature'].toString(),
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
                          'Humidity : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          doc['sessionHumidity'].toString(),
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
                          'Light Intensity : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          doc['sessionLI'].toString(),
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
                          'Soil Moisture : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          doc['sessionMoisture'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            }),
      ),
    );
  }
}
