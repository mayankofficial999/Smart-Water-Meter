import 'package:flutter/material.dart';

Widget banner(int devices,bool status,context) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width-2,
    decoration: BoxDecoration(
      border: Border.all(width: 1,color: Colors.white)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Text('No of logs: $devices',style: const TextStyle(color: Colors.white)),
      const Text('Sync Status: ', style: TextStyle(color: Colors.white)),
      Icon(status ? Icons.done : Icons.cancel ,color: status ? Colors.green : Colors.red)
    ],)
  );
}