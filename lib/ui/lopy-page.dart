import 'package:flutter/material.dart';
import 'package:lost_in_pasteur/model/lopy-status.dart';

class LopyPage extends StatelessWidget {

  final LopyStatus lopyStatus;

  const LopyPage({Key key, this.lopyStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = new ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: <Widget>[
        new TextFormField(
          decoration: InputDecoration(
            icon: displayIcon,
            labelText: 'Name',
          ),
        ),
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.message),
            labelText: 'Message',
          ),
        ),
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.perm_identity),
            labelText: 'ESP ID',
          ),
          readOnly: true,
        ),
        new TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.bubble_chart),
            labelText: 'État',
          ),
          readOnly: true,
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
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('État du LoPy'),
        actions: <Widget>[
        ],
      ),
      body: body,
    );
  }
}
