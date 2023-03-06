import 'dart:convert';
import 'package:flutter/material.dart';

Widget deviceList(data) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (data as List).length,
      itemBuilder: ((context, index) {
        //print(data);
        return ListTile(
          tileColor: index%2==0 ? Colors.black45 : Colors.black12,
          style: ListTileStyle.drawer,
          leading: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              'Time: ${jsonDecode((data as List)[index])["time"]} min',
              style: const TextStyle(color: Colors.white)
            ),
          ),
          title: Text(
            'Flow Rate: ${jsonDecode((data as List)[index])["flow"]} Lt/hr',
            style:  const TextStyle(color: Colors.white,fontSize: 14)
          ),
          subtitle: Text(
            'ID: ${jsonDecode((data as List)[index])["meter_id"]}',
            style:  const TextStyle(color: Colors.white, fontSize: 12)
          ),
          trailing: Text(
            'Total flow: ${jsonDecode((data as List)[index])["total"]} Lts',
            style:  const TextStyle(color: Colors.white)
          ),
          contentPadding: const EdgeInsets.all(20),
        );
      })
    );
}