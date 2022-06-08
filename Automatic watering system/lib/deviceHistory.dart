// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/deviceInformation.dart';
import 'package:hehe/history.dart';

class DeviceHistory extends StatefulWidget {
  final String devID;
  const DeviceHistory({Key? key, required this.devID}) : super(key: key);

  @override
  State<DeviceHistory> createState() => _DeviceHistoryState();
}

class _DeviceHistoryState extends State<DeviceHistory> {
  bool isLoading = true;
  String? devID;

  @override
  void initState() {
    devID = widget.devID;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference deviceIDref =
        FirebaseFirestore.instance.collection('device').doc(devID);
    bool shouldpop = true;
    const primaryColor = Color(0xFFf7be7c);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeviceInformation(deviceID: devID as String)));
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'History',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: primaryColor,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('history')
                .where('devReference', isEqualTo: deviceIDref)
                .orderBy('sessionDate')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  DateTime printSession = doc['sessionDate'].toDate();

                  return Card(
                    child: ListTile(
                      title: Text('$printSession'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionHistory(
                                deviceID: devID as String,
                                historyID: (snapshot.data!.docs[index].id)),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
