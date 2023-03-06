import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

Future<Map<String,String>> getBluetoothData() async {
  Map<String,String> waterData = {"meter_id": "0","flow": "0", "total": "0", "time": "0"};
  List<String> allowedCharacteristics = ['1243a672-bb82-11ed-afa1-0242ac120002','1243aa1e-bb82-11ed-afa1-0242ac120002','1243ac58-bb82-11ed-afa1-0242ac120002'];
  var completer = Completer<Map<String,String>>();
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // Start BLE Scan
  var results = await flutterBlue.startScan(timeout: const Duration(seconds: 2));
  
  for (ScanResult r in results) {
      // Search for our device name
      if(r.device.name == 'ESP32-BLE-Server') {
        var x = DateTime.now().millisecondsSinceEpoch;
        // Establish a temporary connection
        await r.device.connect();
        waterData.update("meter_id",((value) => r.device.id.toString()),ifAbsent: () => r.device.id.toString());
        print("Time to connect: ${(DateTime.now().millisecondsSinceEpoch-x)/1000} sec");
        x = DateTime.now().millisecondsSinceEpoch;
        // Get the available services
        List<BluetoothService> services = await r.device.discoverServices();
        print("Time to discover: ${(DateTime.now().millisecondsSinceEpoch-x)/1000} sec");
        x = DateTime.now().millisecondsSinceEpoch;
        // Iterate through services and characterictics to extract data
        for (var service in services) {
          if(service.uuid.toString()=='4fafc201-1fb5-459e-8fcc-c5c9c331914b'){
            for (var charac in service.characteristics) {
              if(allowedCharacteristics[0] == charac.uuid.toString()) {
                List<int> readData = await charac.read();
                String mainData = String.fromCharCodes(readData);
                waterData.update("flow",((value) => mainData),ifAbsent: () => mainData);
                
              }
              else if(allowedCharacteristics[1] == charac.uuid.toString()) {
                List<int> readData = await charac.read();
                String mainData = String.fromCharCodes(readData);
                waterData.update("total",((value) => mainData),ifAbsent: () => mainData);
                
              }
              else if(allowedCharacteristics[2] == charac.uuid.toString()) {
                List<int> readData = await charac.read();
                String mainData = String.fromCharCodes(readData);
                waterData.update("time",((value) => mainData),ifAbsent: () => mainData);
                
              }
            }
            break;
          }
      }
      print("Time to extract data: ${(DateTime.now().millisecondsSinceEpoch-x)/1000} sec");
        x = DateTime.now().millisecondsSinceEpoch;
      // Disconnect after data collection.
      await r.device.disconnect();
      print("Time to disconnect: ${(DateTime.now().millisecondsSinceEpoch-x)/1000} sec");
        x = DateTime.now().millisecondsSinceEpoch;
      //print(waterData);
      completer.complete(waterData);
      waterData = {"meter_id": "0","flow": "0", "total": "0", "time": "0"};
    }
  }
  // Stop Scanning
  flutterBlue.stopScan();
  return completer.future;
}