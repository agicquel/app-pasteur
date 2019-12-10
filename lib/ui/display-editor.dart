import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_in_pasteur/model/display.dart';
import 'package:lost_in_pasteur/req/display-request.dart';
import 'package:lost_in_pasteur/ui/homepage.dart';

import 'display-history-list.dart';

class DisplayEditor extends StatefulWidget {
  final Display display;

  const DisplayEditor({Key key, this.display}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DisplayEditorState();
  }
}

class DisplayEditorState extends State<DisplayEditor> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _displayNameTextController = new TextEditingController();
  var _displayMessageTextController = new TextEditingController();
  Display useDisplay;
  bool loadingState;

  @override
  void initState() {
    super.initState();
    if (widget.display != null) {
      useDisplay = widget.display;
      _displayNameTextController.text = useDisplay.name;
      _displayMessageTextController.text = useDisplay.message;
    }
    loadingState = false;
  }

  @override
  void dispose() {
    _displayNameTextController.dispose();
    _displayMessageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body;
    Color decoColor = Colors.green;
    var statusText = "En ligne et synchronisé";
    if(useDisplay.lastLopy.isEmpty || useDisplay.lastLopy == "null") {
      decoColor = Colors.red;
      statusText = "Hors ligne";
    }
    else if(!useDisplay.lopyMessageSync) {
      decoColor = Colors.orange;
      statusText = "En cours de synchronisation";
    }

    var displayIcon = new Container(
      width: 32,
      height: 32,
      child: Icon(Icons.cloud_queue, color: Colors.black,),
      decoration: new BoxDecoration(
        color: decoColor.withOpacity(0.5),
        shape: BoxShape.circle,

      ),
    );

    if (loadingState) {
      body = new SpinKitWave(color: Theme.of(context).primaryColor);
    } else {
      body = new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: InputDecoration(
                      icon: displayIcon,
                      labelText: 'Name',
                    ),
                    controller: _displayNameTextController,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.message),
                      labelText: 'Message',
                    ),
                    controller: _displayMessageTextController,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.perm_identity),
                      labelText: 'ESP ID',
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: useDisplay.espId),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.bubble_chart),
                      labelText: 'État',
                    ),
                    readOnly: true,
                    controller: TextEditingController(text: statusText),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: new RaisedButton(
                          child: const Text('Sauvegarder'),
                          onPressed: () async {
                            Display display = _generateFromForm();
                            setState(() {
                              loadingState = true;
                            });
                            //FocusScope.of(context).detach();
                            FocusScope.of(context).unfocus();
                            bool ok =
                                await DisplayRequest.updateDisplay(display);
                            if (ok) {
                              Navigator.pop(context);
                            } else {
                              //Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Une erreur est survenue")));
                              setState(() {
                                loadingState = false;
                              });
                            }
                          })),
                ],
              )));
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Modifier l\'afficheur'),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> entries =
                  List<PopupMenuEntry<String>>();
              if(HomepageState.connectionState == 0) {
                entries.add(PopupMenuItem<String>(
                    value: "delete", child: Text("Supprimer")));
              }
              entries.add(PopupMenuItem<String>(
                  value: "history", child: Text("Historique")));
              entries.add(PopupMenuItem<String>(
                  value: "lopy", child: Text("Routeur associé")));
              return entries;
            },
            onSelected: (String selected) async {
              if (selected == "delete") {
                Display display = _generateFromForm();
                setState(() {
                  loadingState = true;
                });
                //FocusScope.of(context).detach();
                FocusScope.of(context).unfocus();
                bool ok =
                    await DisplayRequest.removeDisplay(display);
                if (ok) {
                  Navigator.pop(context);
                } else {
                  //Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Une erreur est survenue")));
                  setState(() {
                    loadingState = false;
                  });
                }
              }
              else if(selected == "history") {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DisplayHistoryScrollableView(
                          history: useDisplay.history,
                        )));
              }
              else if(selected == "lopy") {

              }
            },
          )
        ],
      ),
      body: body,
    );
  }

  Display _generateFromForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      throw Exception('form is not valide');
    } else {
      Display newDisplay = new Display(
          id: useDisplay.id,
          name: _displayNameTextController.text,
          message: _displayMessageTextController.text,
          espId: useDisplay.espId,
          createdAt: useDisplay.createdAt,
          updatedAt: useDisplay.updatedAt,
          lopyMessageSeq: useDisplay.lopyMessageSeq,
          lopyMessageSync: useDisplay.lopyMessageSync,
          lastLopy: useDisplay.lastLopy,
          history: useDisplay.history);
      return newDisplay;
    }
  }
}
