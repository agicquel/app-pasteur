import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_in_pasteur/model/display.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'display-editor.dart';

class DisplayScrollableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DisplayScrollableViewState();
  }
}

class DisplayScrollableViewState extends State<DisplayScrollableView> {
  List<Display> _displays;
  bool loadingState;

  @override
  Widget build(BuildContext context) {
    if (loadingState) {
      return new SpinKitWave(
        color: Theme.of(context).primaryColor,
      );
    } else {
      return new LiquidPullToRefresh(
          onRefresh: _updateDisplays,
          child: ListView.builder(
              itemCount: _displays.length,
              itemBuilder: (context, index) {
                Display display = _displays[index];
                Color decoColor = Colors.green;
                if(display.lastLopy.isEmpty || display.lastLopy == "null") {
                  decoColor = Colors.red;
                }
                else if(!display.lopyMessageSync) {
                  decoColor = Colors.orange;
                }
                ListTile tile = new ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.cloud_queue, color: Colors.black,),
                    decoration: new BoxDecoration(
                      color: decoColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: new Text('Nom : ' + display.name),
                  subtitle: Text('ESP : ' +
                      display.espId +
                      '\nMessage : ' +
                      display.message),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new DisplayEditor(
                                  display: display,
                                ))).then((value) {
                      _updateDisplays();
                    });
                  },
                );
                return new Card(
                    elevation: 6.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: tile);
              }));
    }
  }

  Future<void> _updateDisplays() async {
    loadingState = true;
    try {
      var displays = await DisplayRequest.fetchDisplay();
      if (mounted) {
        setState(() {
          _displays = displays;
          loadingState = false;
        });
      }
    } catch (e) {
      setState(() {
        _displays = List<Display>();
        if (mounted) loadingState = false;
      });
    }
  }

  @override
  void initState() {
    _displays = [];
    _updateDisplays();
  }
}
