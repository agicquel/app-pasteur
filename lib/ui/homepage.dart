import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:lost_in_pasteur/req/request-constant.dart';
import 'displays-list.dart';
import 'login-page.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomepageState();
  }
}

class HomepageState extends State<Homepage> {
  StreamSubscription<ConnectivityResult> connectionListener;
  int selectedPos = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String titleAppBar = "";
  bool _identified = true;
  TextEditingController _macEspFieldController = TextEditingController();

  @override
  initState() {
    super.initState();
    connectionListener = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      checkConnectivity();
    });
    checkJwt();
    checkConnectivity();
    titleAppBar = "Mes afficheurs";
  }

  void checkJwt() async {
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'jwt');
    print("key = " + key.toString());
    setState(() {
      if (key == null) {
        _identified = false;
      }
    });
  }

  void checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      saveUrl(ConstantRequest.fullUrl);
      setState(() {
        selectedPos = _identified ? 0 : 2;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      String ssid = await Connectivity().getWifiName();
      if (ssid == null) {
        PermissionStatus permission =
            await LocationPermissions().checkPermissionStatus();
        if (permission != PermissionStatus.granted) {
          PermissionStatus newPermission =
              await LocationPermissions().requestPermissions();
          if (newPermission != PermissionStatus.granted) {
            saveUrl(ConstantRequest.fullUrl);
            setState(() {
              selectedPos = 3;
            });
          } else {
            checkConnectivity();
          }
        }
      } else if (ssid.startsWith('Lopy_HP_')) {
        saveUrl(ConstantRequest.lopyUrl);
        setState(() {
          selectedPos = 1;
        });
      } else {
        saveUrl(ConstantRequest.fullUrl);
        setState(() {
          selectedPos = _identified ? 0 : 2;
        });
      }
    } else {
      setState(() {
        selectedPos = 3;
      });
    }
  }

  void saveUrl(String url) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'api_url', value: url);
  }

  @override
  dispose() {
    super.dispose();
    connectionListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.1,
        title: new Text(titleAppBar),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> entries =
                  List<PopupMenuEntry<String>>();
              if (_identified) {
                entries.add(PopupMenuItem<String>(
                    value: "connection", child: Text("Se déconnecter")));
              } else {
                entries.add(PopupMenuItem<String>(
                    value: "deconnection", child: Text("Se connecter")));
              }
              return entries;
            },
            onSelected: (String selected) {
              print("ici callback");
              if (_identified) {
                final storage = new FlutterSecureStorage();
                storage.deleteAll();
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => new LoginPage()),
              );
            },
          )
        ],
      ),
      floatingActionButton: getFloatingActionButton(context),
      body: bodyContainer(),
    );
  }

  FloatingActionButton getFloatingActionButton(BuildContext context) {
    FloatingActionButton floatingActionButton = null;
    switch (selectedPos) {
      case 0:
        floatingActionButton = FloatingActionButton(
            onPressed: () => _addDisplayDialog(context),
            child: Icon(
              Icons.add,
            ));
        break;
      case 1:
      case 2:
      case 3:
        floatingActionButton = null;
        break;
    }
    return floatingActionButton;
  }

  Widget bodyContainer() {
    Widget selectedWidget;
    switch (selectedPos) {
      case 0:
      case 1:
        selectedWidget = new DisplayScrollableView();
        break;
      case 2:
        selectedWidget = Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cloud_off,
                  size: 150,
                ),
                Text(
                    "Veillez vous identifier ou \nalors connectez vous à un LoPy.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
        );
        break;
      case 3:
        selectedWidget = Padding(
          padding: EdgeInsets.only(bottom: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'graphics/logo-rond-sad.png',
                  width: 150,
                  height: 150,
                ),
                Text("Pas de connexion !",
                    style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
              ],
            ),
          ),
        );
    }

    return selectedWidget;
  }

  void _addDisplayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ajouter un afficheur'),
            content: TextField(
              controller: _macEspFieldController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(hintText: "Code de l'afficheur"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Ajouter'),
                onPressed: () {
                  addDisplay(context, _macEspFieldController.text.toString());
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void addDisplay(BuildContext context, String espId) async {
    bool res = await DisplayRequest.declareDisplay(espId);
    if(res) {
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Afficheur ajouté avec succès.')));
      setState(() {});
    }
    else {
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Erreur lors de l'ajout de l'afficheur.")));
    }
  }
}
