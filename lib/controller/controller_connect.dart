import 'dart:async';
import 'dart:io';

import 'package:app_connect_bot/variables/var.dart';
import 'package:app_connect_bot/view/view_connect_bot.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ControllerConnect extends StatefulWidget {
   const ControllerConnect({
    super.key,
    required this.title,
  });

  final String title;


  @override
  State<ControllerConnect> createState() => _ControllerConnectState();
}

class _ControllerConnectState extends State<ControllerConnect> {

  Socket? socket;

  bool boolStatusConnectToSocketServer = false;
  bool boolStatusSendDataToSocketServer = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //connectWifiSocketAndSendCredential();
    setState(() {
      //---- actualiser l'etat des ecrans
    });

    StreamSubscription<ConnectivityResult> subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print(" Result connectivity is ::  ${result}");

      //connectWifiSocketAndSendCredential();
      //---- actualiser l'etat des ecrans
      setState(() {
        //---- actualiser l'etat des ecrans
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return ViewConnectBot(
      title: widget.title,
      getConnectWifi: getConnectWifi,
      getAssetImageWifi: getAssetImageWifi,
      checkWifiAndPrintIp: checkWifiAndPrintIp,
      connectWifiSocketAndSendCredential: connectWifiSocketAndSendCredential,
      boolStatusConnectToSocketServer: boolStatusConnectToSocketServer,
      boolStatusSendDataToSocketServer: boolStatusSendDataToSocketServer,
    );
  }



  Future<bool> getConnectWifi() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
    } else if (connectivityResult == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network.
    }
    return false;

  }


  //---- get asset image en fonction de la connectivité de la methode getConnectWifi
  String getAssetImageWifi(bool isConnect) {
    if (isConnect) {
      return 'assets/images/succes.png';
    } else {
      return 'assets/images/error.png';
    }
  }

  Future<String> checkWifiAndPrintIp() async {
    // Vérification de la connexion Wi-Fi
    bool isConnected = await getConnectWifi();

    if (isConnected) {
      try {
        // Liste des interfaces réseau disponibles
        List<NetworkInterface> interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, // On filtre pour obtenir des adresses IPv4
          includeLoopback: false, // On exclut les interfaces de loopback (127.0.0.1)
        );

        // Parcours des interfaces pour trouver l'adresse IP
        for (var interface in interfaces) {
          for (var addr in interface.addresses) {
            print('Adresse IP: ${addr.address}');
            return addr.address;
          }
        }
      } catch (e) {
        print('Erreur lors de la récupération de l\'adresse IP: $e');
        return 'N/A';
      }
    } else {
      print('Wi-Fi non connecté.');
      return 'N/A';
    }
    return 'N/A';
  }

  String modifyIp(String ipAddress) {
    // Sépare l'adresse IP en plusieurs parties à l'aide du point comme séparateur
    List<String> parts = ipAddress.split('.');

    // Vérifie que l'adresse IP a bien 4 parties
    if (parts.length == 4) {
      // Remplace le dernier octet par "1"
      parts[3] = '1';

      // Reconstruit l'adresse IP et la retourne
      return parts.join('.');
    } else {
      // Si l'adresse IP n'est pas valide, renvoie une erreur ou une adresse par défaut
      return 'Invalid IP Address';
    }
  }


  //--- methode Update statue connect socket
  Future<bool> statusConnectToSocketServer (bool newStatus) async{
    print("Change Status Connect to Socket Server : $newStatus");
    boolStatusConnectToSocketServer = newStatus;
    setState(() {
      print("--------- ecran actualisé avec le nouveau status de connexion au serveur socket : $newStatus");
    });
    return newStatus;
  }

  //---- methode Update statut send data in web socket
  Future<bool> statusSendDataToSocketServer (bool newStatus) async{
    print("Change Status Send Data to Socket Server : $newStatus");
    boolStatusSendDataToSocketServer= newStatus;
    setState(() {
      print("--------- ecran actualisé avec le nouveau status d'envoi de données au serveur socket : $newStatus");
    });
    return newStatus;
  }

  Future<void> connectToSocketServer(String ipAddress, int port) async {



    try {
      // Tente de se connecter au serveur socket avec l'adresse IP et le port spécifiés
      print("try to connect to socket server $ipAddress and port $port");
      socket = await Socket.connect(ipAddress, port);
      //---- verifier si socket connecter avec succes
      statusConnectToSocketServer(true);

      //socket = await Socket.connect("127.0.0.1", 8080);
      print('Connected to: ${socket?.remoteAddress.address}:${socket?.remotePort}');
      // Vous pouvez ici envoyer des données au serveur via le socket
      //socket?.write('Hello Server!');
      socket?.write(credentialSave.toJson());


      // Vous pouvez également écouter les données entrantes du serveur
      socket?.listen(
            (data) async {
          print('Received: ${String.fromCharCodes(data)}');
          if(String.fromCharCodes(data) == 'success') {
            statusConnectToSocketServer(true);
            statusSendDataToSocketServer(true);
          }else{
            statusConnectToSocketServer(true);
            statusSendDataToSocketServer(false);
          }

        },
        onError: (error) {
          print('Error: $error');
          socket?.destroy(); // Fermer la connexion en cas d'erreur
          statusSendDataToSocketServer(false);
          statusConnectToSocketServer(false);
        },
        onDone: () {
          print('Server closed the connection');
          socket?.destroy(); // Fermer la connexion proprement
         statusConnectToSocketServer(false);
         statusSendDataToSocketServer(false);
        },
      );


    } catch (e) {
      print('Error: Could not connect to the socket server: $e');
      statusConnectToSocketServer(false);
     // statusConnectToSocketServer(false);
    }




  }


  Future<bool> connectWifiSocketAndSendCredential() async {

    String ipAddress = await checkWifiAndPrintIp();
    String modifiedIp;
    if (ipAddress == 'N/A') {
      print('Adresse IP non disponible.');
      return false;
    }else{
      print('Adresse IP: $ipAddress');
      modifiedIp = modifyIp(ipAddress);
      print('Adresse IP modifiée (recuperation Adress Serveur) socket : $modifiedIp');

      //connectToSocketServer(modifiedIp, 8765);
      await connectToSocketServer(modifiedIp, port_server_socket);
      //await connectToSocketServer("192.168.137.1", 3235);
    }

    print("connectWifiSocketAndSendCredential ------------- est a true");
    return getConnectWifi();
  }



}
