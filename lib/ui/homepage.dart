import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:lost_in_pasteur/req/request-constant.dart';
import 'package:lost_in_pasteur/ui/no-connection.dart';
import 'package:lost_in_pasteur/ui/request-connection.dart';
import 'displays-list.dart';
import 'login-page.dart';
import 'lopys-list.dart';

class Homepage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return new HomepageState();
  }
}

class HomepageState extends State<Homepage> {
  StreamSubscription<ConnectivityResult> connectionListener;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _titleAppBar = ["Mes afficheurs", "Mes routeurs", "État du réseau", "Paramètres", "Pas de réseau", "Demande de connexion"];
  var _barColors = [Colors.red, Colors.purpleAccent, Colors.pink, Colors.blue];
  bool _identified = true;
  TextEditingController _macEspFieldController = TextEditingController();
  TextEditingController _lopySsidFieldController = TextEditingController();
  PageController _pageController;

  /// 0 : Connected to a 4G network and identified
  /// 1 : Connected to a LoPy network
  /// 2 : Connected but not identified
  /// 3 : No connection
  static int connectionState = 3;

  /// 0 : Displays
  /// 1 : Lopys
  /// 2 : Network
  /// 3 : Settings
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
    _pageController = PageController();
    connectionListener = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      checkConnectivity();
    });
    checkJwt();
    checkConnectivity();

  }

  void checkJwt() async {
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'jwt');
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
        connectionState = _identified ? 0 : 2;
        _currentIndex = _identified ? 0 : 4;
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
              connectionState = 3;
              _currentIndex = 5;

            });
          } else {
            checkConnectivity();
          }
        }
      } else if (ssid.startsWith('Lopy_HP_')) {
        saveUrl(ConstantRequest.lopyUrl);
        setState(() {
          connectionState = 1;
          _currentIndex = 0;
        });
      } else {
        saveUrl(ConstantRequest.fullUrl);
        setState(() {
          connectionState = _identified ? 0 : 2;
          _currentIndex = _identified ? 0 : 4;
        });
      }
    } else {
      setState(() {
        connectionState = 3;
        _currentIndex = 5;
      });
    }
  }

  void saveUrl(String url) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'api_url', value: url);
  }

  @override
  dispose() {
    _pageController.dispose();
    connectionListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(),
      floatingActionButton: getFloatingActionButton(context),
      //body: bodyContainer(),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            new DisplayScrollableView(),
            new LopyScrollableView(),
            Container(color: Colors.white,),
            Container(color: Colors.white,),
            NoConnection(),
            RequestConnection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.devices),
            title: Text('Afficheurs'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.router),
              title: Text('Routeurs'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.multiline_chart),
              title: Text('Réseau'),
              activeColor: Colors.pink
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Paramètres'),
              activeColor: Colors.blue
          ),
        ],
      ),
    );
  }

  FloatingActionButton getFloatingActionButton(BuildContext context) {
    if(_currentIndex != 0) return null;

    FloatingActionButton floatingActionButton;
    switch (connectionState) {
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
                  _addDisplay(context, _macEspFieldController.text.toString());
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _addDisplay(BuildContext context, String espId) async {
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

  void _renameLopyDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Renommer le LoPy'),
            content: TextField(
              controller: _lopySsidFieldController,
              decoration: InputDecoration(hintText: "Nouveau nom"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Sauvegarder'),
                onPressed: () {
                  _renameLopy(context, _lopySsidFieldController.text.toString());
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _renameLopy(BuildContext context, String ssid) async {
    bool res = await DisplayRequest.getRenameLopy(ssid);
    if(res) {
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('LoPy renommé avec succès.')));
      setState(() {});
    }
    else {
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Impossible de renommer le LoPy.")));
    }
  }

  getAppBar() {
    return new AppBar(
      elevation: 0.1,
      title: new Text(_titleAppBar[_currentIndex]),
      //backgroundColor: _barColors[_currentIndex],
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
            if(_currentIndex == 0 && connectionState == 1) {
              entries.add(PopupMenuItem<String>(
                  value: "rename", child: Text("Renommer le LoPy")));
            }
            return entries;
          },
          onSelected: (String selected) {
            if(selected == "rename") {
              _renameLopyDialog(context);
            }
            else {
              if (_identified) {
                final storage = new FlutterSecureStorage();
                storage.deleteAll();
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => new LoginPage()),
              );
            }
          },
        )
      ],
    );
  }
}
