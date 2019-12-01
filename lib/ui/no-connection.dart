
import 'package:flutter/cupertino.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'graphics/logo-rond-sad.png',
              width: 150,
              height: 150,
            ),
            Text("Pas de connexion !",
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }

}