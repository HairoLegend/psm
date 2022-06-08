// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/deviceInformation.dart';

class DeviceSchedule extends StatefulWidget {
  final String devID;
  const DeviceSchedule({Key? key, required this.devID}) : super(key: key);

  @override
  State<DeviceSchedule> createState() => _DeviceScheduleState();
}

class _DeviceScheduleState extends State<DeviceSchedule> {
  DateTime dateTime = DateTime.now();
  bool isLoading = true;
  String? devID;

  @override
  void initState() {
    devID = widget.devID;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
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
              'Schedule',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: primaryColor,
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule')
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
                      title: Text(
                        '$printSession',
                      ),
                      onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Schedule'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Are you sure to delete this schedule?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      final scheduleDel = FirebaseFirestore
                                          .instance
                                          .collection('schedule')
                                          .doc(doc.id);
                                      scheduleDel.delete();
                                      Navigator.pop(context, 'Yes');
                                    },
                                  ),
                                ],
                              )),
                    ));
                  },
                  // itemCount: images.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: pickDateTime,
            tooltip: 'Add Session',
            heroTag: 'ScheduleTag',
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ));
  }

// call both pick date and time method
  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => this.dateTime = dateTime);

    Timestamp myTimeStamp = Timestamp.fromDate(dateTime);
    final deviceIDref =
        FirebaseFirestore.instance.collection('device').doc(devID);
    createSchedule(sessionDate: myTimeStamp, devReference: deviceIDref);
  }

// pick date method
  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));

// pick time method
  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

  Future createSchedule({
    required Timestamp sessionDate,
    required DocumentReference devReference,
  }) async {
    final docSchedule = FirebaseFirestore.instance.collection('schedule').doc();

    final schedule = Schedule(
      id: docSchedule.id,
      devReference: devReference,
      sessionDate: sessionDate,
    );
    final json = schedule.toJson();

    await docSchedule.set(json);
  }
}

class Schedule {
  String id;
  DocumentReference devReference;
  Timestamp sessionDate = Timestamp.now();

  Schedule({
    this.id = '',
    required this.devReference,
    required this.sessionDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'devReference': devReference,
        'sessionDate': sessionDate,
      };

  static Schedule fromJson(Map<String, dynamic> json) => Schedule(
        devReference: json['devReference'],
        sessionDate: json['sessionDate'],
      );
}
