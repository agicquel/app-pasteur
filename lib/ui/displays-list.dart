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
    if(loadingState) {
      return new SpinKitWave(color: Theme.of(context).primaryColor,);
    }
    else {
      return new LiquidPullToRefresh(
          onRefresh: _updateDisplays,
          child: ListView.builder(
              itemCount: _displays.length,
              itemBuilder: (context, index) {
                Display display = _displays[index];
                return new ListTile(
                  leading: Icon(Icons.cloud_queue),
                  title: new Text('Name : ' + display.name),
                  subtitle: Text('Message : ' + display.message),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator
                        .push(context, new MaterialPageRoute(builder: (context) => new DisplayEditor(display: display,)))
                        .then((value) {
                          _updateDisplays();
                    });
                  },
                );
              })
      );
    }
  }

  Future<void> _updateDisplays() async {
    loadingState = true;
    var displays = await DisplayRequest.fetchDisplay();
    setState(() {
      _displays = displays;
      loadingState = false;
    });
  }

  @override
  void initState() {
    _displays = [];
    _updateDisplays();
  }



}