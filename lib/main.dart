import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJson();
  List _features = _data['features'];
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          'Quakes',
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        backgroundColor: Colors.red.shade500,
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _features.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int position) {
            final index = position ~/ 2;
            int date1 = _features[index]['properties']['time'];
            DateTime date = new DateTime.fromMillisecondsSinceEpoch(date1);
            var format = new DateFormat.yMMMMd("en_US").add_jm();
            var dateString = format.format(date);

            if (position.isOdd) {
              return Divider();
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.greenAccent.shade700,
                child: Text(
                  '${_features[index]['properties']['mag']}',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
              title: Text('${dateString}',
                  style: TextStyle(
                    color: Colors.orangeAccent.shade700,
                    fontSize: 25.0,
                  )),
              subtitle: Text(
                _features[index]['properties']['place'],
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black38,
                    fontStyle: FontStyle.italic),
              ),
              onTap: () {
                showDialogueBox(
                    context, '${_features[index]['properties']['title']}');
              },
            );
          }),
    ),
  ));
}

Future<Map> getJson() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

void showDialogueBox(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Quakes',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      });
}
