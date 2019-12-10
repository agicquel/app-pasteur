import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_in_pasteur/model/display-history.dart';
import 'package:lost_in_pasteur/model/display.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'display-editor.dart';

class DisplayHistoryScrollableView extends StatelessWidget {
  final List<DisplayHistory> history;

  const DisplayHistoryScrollableView({Key key, this.history}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Historique de l\'afficheur'),
      ),
      body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            DisplayHistory displayHistory = history[index];
            ListTile tile = new ListTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.black,),
              title: new Text('Message : ' + displayHistory.message),
              subtitle: Text('Auteur : ' +
                  displayHistory.user +
                  '\nDate : ' +
                  displayHistory.time),
              onTap: () {
              },
            );
            return new Card(
                elevation: 6.0,
                margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
                child: tile);
          }),
    );
  }

}
