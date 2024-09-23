import 'package:flutter/material.dart';


class ViewConnectBot extends StatefulWidget {
  String title;
  //-- ajouter un paramettre function
  //final Function() getConnectWifi;

  //-- ajouter un paramettre function Future<bool>
  final Future<bool> Function() getConnectWifi;
  //--- ajouter en paramettre un function getAssetImageWifi(bool isConnect)
  final Function(bool isConnect) getAssetImageWifi;
  //--- ajouter en paramettre la fonction Future<String> checkWifiAndPrintIp()
  final Future<String> Function() checkWifiAndPrintIp;
  //---- Funtion execution connection wifi , conction socket et envoie des credentials
  final Future<bool> Function() connectWifiSocketAndSendCredential;
  //---- Funtion execution statut connection socket bool statusConnectToSocketServer (bool newStatus) une fonction non futur
  final bool boolStatusConnectToSocketServer;
  //---- Funtion execution statut envoie des credentials bool statusSendDataToSocketServer (bool newStatus) une fonction non futur
  final bool boolStatusSendDataToSocketServer;


  bool isConnect = false;


  ViewConnectBot({
    super.key,
    required this.title,
    required this.getConnectWifi,
    required this.getAssetImageWifi,
    required this.checkWifiAndPrintIp,
    required this.connectWifiSocketAndSendCredential,
    required this.boolStatusConnectToSocketServer,
    required this.boolStatusSendDataToSocketServer,

  });

  @override
  State<ViewConnectBot> createState() => _ViewConnectBotState();
}

class _ViewConnectBotState extends State<ViewConnectBot> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }

  bool isSend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                Image.asset(
                  'assets/images/robot.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 40,),

                FutureBuilder<bool>(
                  future: widget.getConnectWifi(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/wifi.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 15,),
                                  const Text(
                                    "Step 1- Connect Wifi",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ), // Pour montrer que c'est en attente
                                ],
                              ),


                              CircularProgressIndicator(), // Pour montrer que c'est en attente
                            ],
                          ),
                        );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      bool isConnect = snapshot.data ?? false;
                      return

                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            color: isConnect ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/wifi.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 15,),
                                  const Text(
                                    "Step 1- Connect Wifi",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),

                              Image.asset(
                                '${widget.getAssetImageWifi(isConnect)}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        );
                    }
                  },
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: widget.boolStatusConnectToSocketServer ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          Image.asset(
                            'assets/images/reseau-local.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 15,),
                          const Text(
                            "Step 2- Socket Connect",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),


                      Image.asset(
                        '${widget.getAssetImageWifi(widget.boolStatusConnectToSocketServer)}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),

                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: widget.boolStatusSendDataToSocketServer ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/credential.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 15,),
                                  const Text(
                                    "Step 3- Credential Send",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),


                              Image.asset(
                                '${widget.getAssetImageWifi(widget.boolStatusSendDataToSocketServer)}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),

              ]
            ),



            Column(
              children: [
                InkWell(
                        child: Image.asset(
                          widget.boolStatusSendDataToSocketServer ? 'assets/images/connect.png' : 'assets/images/no_connect.png' ,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        onTap: () async {
                          //String ip = await widget.checkWifiAndPrintIp();
                          //print(ip);
                          await widget.connectWifiSocketAndSendCredential();

                          //await widget.connectWifiSocketAndSendCredential();
                        },
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
