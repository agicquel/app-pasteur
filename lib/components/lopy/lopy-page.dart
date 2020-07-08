import 'package:flutter/material.dart';
import 'package:lost_in_pasteur/model/lopy.dart';

class LopyPage extends StatelessWidget {

  final Lopy lopy;

  const LopyPage({Key key, this.lopy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var body = new ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: <Widget>[
        new TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.router, color: Colors.black,),
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
        )
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
