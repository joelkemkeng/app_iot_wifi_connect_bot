import 'package:app_connect_bot/controller/controller_connect.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Connect Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:  ControllerConnect(
          title: 'Connect Bot',
          port_server_socket: 8765,
          credential: '{"ssid":"nom_du_wifi","password":"mot_de_passe"}',
      ),
    );
  }
}

