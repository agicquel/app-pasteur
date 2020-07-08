import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_in_pasteur/model/display.dart';
import 'package:lost_in_pasteur/model/lopy.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lost_in_pasteur/req/lopy-request.dart';
import '../display/display-editor.dart';
import 'lopy-page.dart';

class LopyScrollableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LopyScrollableViewState();
  }
}

class LopyScrollableViewState extends State<LopyScrollableView> {
  List<Lopy> _lopys;
  bool loadingState;

  @override
  Widget build(BuildContext context) {
    if (loadingState) {
      return new SpinKitWave(
        color: Theme
            .of(context)
            .primaryColor,
      );
    } else {
      return new LiquidPullToRefresh(
          onRefresh: _updateLopys,
          child: ListView.builder(
              itemCount: _lopys.length,
              itemBuilder: (context, index) {
                Lopy lopy = _lopys[index];
                ListTile tile = new ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.router, color: Colors.black,),
                  ),
                  title: new Text('MAC : ' + lopy.mac),
                  subtitle: Text('current seq : ' +
                      lopy.currentSeq.toString() +
                      '\nupdate : ' +
                      lopy.updatedAt),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                            new LopyPage(lopy: lopy,
                            ))).then((value) {});
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

  Future<void> _updateLopys() async {
    loadingState = true;
    try {
      var lopys = await LopyRequest.fetchLopy();
      if (mounted) {
        setState(() {
          _lopys = lopys;
          loadingState = false;
        });
      }
    } catch (e) {
      setState(() {
        _lopys = List<Lopy>();
        if (mounted) loadingState = false;
      });
    }
  }

  @override
  void initState() {
    _lopys = [];
    _updateLopys();
  }
}
