import 'dart:convert';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/material.dart';
import 'package:sdn_project/components/banner.dart';
import 'package:sdn_project/components/deviceList.dart';
import 'package:sdn_project/util/timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool syncStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(5, 5, 5, 1),
      ),
      body:  FutureBuilder(
        initialData: [jsonEncode({})],
        future: (TaskTimer().getData()),
        builder: ((context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white,));
          }
          else {
            return 
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  banner((snapshot.data as List).length,syncStatus,context),
                  Expanded(child:
                    deviceList(snapshot.data),
                  )
                ],
              );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var data = await TaskTimer().getData();
          print('Button: $data');
          EasyFire().getRtdbObject().setData('/Data',data);
          setState(() {
            syncStatus = true;
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  } 

  @override
  void dispose() {
    TaskTimer().stop();
    super.dispose();
  }

}
