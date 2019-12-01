import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_in_pasteur/model/display.dart';
import 'package:lost_in_pasteur/req/display-request.dart';

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
  var _displayEspIdTextController = new TextEditingController();
  Display useDisplay;
  bool loadingState;

  @override
  void initState() {
    super.initState();
    if (widget.display != null) {
      useDisplay = widget.display;
      _displayNameTextController.text = useDisplay.name;
      _displayMessageTextController.text = useDisplay.message;
      _displayEspIdTextController.text = useDisplay.espId;
    }
    loadingState = false;
  }

  @override
  void dispose() {
    _displayNameTextController.dispose();
    _displayMessageTextController.dispose();
    _displayEspIdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var body;
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
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.cloud),
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
                      labelText: 'espId',
                    ),
                    controller: _displayEspIdTextController,
                  ),
                  new Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: new RaisedButton(
                          child: const Text('Supprimer'),
                          onPressed: () async {
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
                          })),
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
          espId: _displayEspIdTextController.text,
          createdAt: useDisplay.createdAt,
          updatedAt: useDisplay.updatedAt,
          lopyMessageSeq: useDisplay.lopyMessageSeq,
          lopyMessageSync: useDisplay.lopyMessageSync,
          lastLopy: useDisplay.lastLopy);
      return newDisplay;
    }
  }
}
