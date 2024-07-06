import 'dart:convert';
import 'dart:io';

import 'package:bavaresco/models/sync/historic_sync.dart';
import 'package:bavaresco/screens/lista/maquina.dart';
import 'package:bavaresco/splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




void main() {
  runApp(
    BavarescoApp(),
  );
}

class BavarescoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

fetchHistoric().then((value) => debugPrint(
    value.toJson()['data'][1].toString()

));
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.greenAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.greenAccent[700],
          textTheme: ButtonTextTheme.accent,
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: Colors.white), // Text color
        ),
      ),
      home:Splash()//ListaMaquinas()
      ,
    );
  }
}

Future<HistoricSync> fetchHistoric() async {
  final response = await http.get('https://easyagro-backend.herokuapp.com/api/historic');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return HistoricSync.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Historic Values');
  }

}

