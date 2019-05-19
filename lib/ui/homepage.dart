import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'displays-list.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';


class Homepage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new HomepageState();
  }
}

class HomepageState extends State<Homepage> {
  StreamSubscription<ConnectivityResult> connectionListener;
  CircularBottomNavigationController _navigationController;
  int selectedPos = 0;
  double bottomNavBarHeight = 60;
  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Afficheurs", Colors.blue),
    new TabItem(Icons.layers, "Groupes", Colors.blue),
    new TabItem(Icons.settings, "Paramètres", Colors.blue),
  ]);
  List<String> titlesAppBar = List.of([
    "Liste des afficheurs",
    "Gestion des groupes d'afficheurs",
    "Gestion des paramètres"
  ]);
  String titleAppBar = "";

  @override
  initState() {
    super.initState();
    connectionListener = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // TODO : gerer quand on perd la connexion internet
    });
    _navigationController = new CircularBottomNavigationController(selectedPos);
    titleAppBar = titlesAppBar[selectedPos];
  }

  @override
  dispose() {
    super.dispose();
    _navigationController.dispose();
    connectionListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(titleAppBar),
      ),
      body: Stack(
        children: <Widget>[
          Padding(child: bodyContainer(), padding: EdgeInsets.only(bottom: bottomNavBarHeight),),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Widget selectedWidget;
    switch (selectedPos) {
      case 0:
        selectedWidget = new DisplayScrollableView();
        break;
      case 1:
        selectedWidget = new Text("Pas encore !");
        break;
      case 2:
        selectedWidget = new Text("Pas encore !");
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: selectedWidget,
        ),
      ),
      onTap: () {
        if (_navigationController.value == tabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value++;
        }
      },
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          titleAppBar = titlesAppBar[selectedPos];
        });
      },
    );
  }

}