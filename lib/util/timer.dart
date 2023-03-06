import 'dart:async';
import 'dart:convert';
import 'package:sdn_project/util/bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskTimer {
  TaskTimer();
  Map<String, String> bleData = {"meter_id": "0","flow": "0", "total": "0", "time": "0"};
  late Timer timer;
  late SharedPreferences prefs;
  void init() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.setStringList("mainData", []);
    List<String> data = [];
    prefs.reload();
    data = prefs.getStringList("mainData")!;
    timer = Timer.periodic(const Duration(seconds: 60), (count) async {
      bleData = await getBluetoothData();
      //print('BLE Data: $bleData');
      data.add(jsonEncode(bleData));
      print('Inside Timer: $data');
      prefs.setStringList("mainData", data);
    });
  }

  Future<List<String>> getData() async {
    prefs = await SharedPreferences.getInstance();
    List<String> data = [];
    prefs.reload();
    data = prefs.getStringList("mainData")!;
    //print('getData: $data');
    return data;
  }
  
  void stop() {
    timer.cancel();
  }
}