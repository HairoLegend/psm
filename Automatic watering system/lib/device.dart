// ignore_for_file: prefer_const_constructors, unused_element, unused_label, unused_local_variable, dead_code, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/dashboard.dart';
import 'package:hehe/deviceInformation.dart';

class DevicePage extends StatefulWidget {
  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFf7be7c);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Device List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: primaryColor,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('device')
                .orderBy('deviceDate', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot devdoc = snapshot.data!.docs[index];

                    return Card(
                        color: Colors.white,
                        elevation: 10.0,
                        margin: const EdgeInsets.fromLTRB(18, 5, 18, 5),
                        shadowColor: Colors.grey.withOpacity(1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(
                              devdoc['deviceName'],
                              style: TextStyle(fontSize: 24),
                            ),
                            subtitle: Text(
                              devdoc['deviceLocation'],
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceInformation(
                                      deviceID:
                                          (snapshot.data!.docs[index].id)),
                                ),
                              );
                            },
                            onLongPress: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Delete Device'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Are you sure to delete this device?'),
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
                                            final deviceDel = FirebaseFirestore
                                                .instance
                                                .collection('device')
                                                .doc(devdoc.id);
                                            final scheduleDel =
                                                FirebaseFirestore.instance
                                                    .collection('schedule')
                                                    .where('devReference',
                                                        isEqualTo: deviceDel);
                                            scheduleDel.get().then((value) {
                                              for (var element in value.docs) {
                                                FirebaseFirestore.instance
                                                    .collection('schedule')
                                                    .doc(element.id)
                                                    .delete();
                                              }
                                            });
                                            deviceDel.delete();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Dashboard(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                          ),
                        )); //
                  });
            }));
  }
}
