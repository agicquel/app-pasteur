import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lost_in_pasteur/req/request-constant.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:lost_in_pasteur/components/homepage.dart';
import 'package:lost_in_pasteur/components/login-page.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Lost in Pasteur',
      home: new MyApp(),
      theme: _buildLightTheme(),
      debugShowCheckedModeBanner: false));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StatefulWidget _displayedWidget;

  @override
  void initState() {
    super.initState();
    checkJwt();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedWidget == null) {
      return Image.asset('graphics/logo-rond.png');
    } else {
      return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: _displayedWidget,
        title: new Text(
          'Lost in Pasteur',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('graphics/logo-rond.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.grey
      );
    }
  }

  void checkJwt() async {
    final storage = new FlutterSecureStorage();
    String key = await storage.read(key: 'jwt');
    await storage.write(key: 'api_url', value: ConstantRequest.fullUrl);
    setState(() {
      if (key == null) {
        _displayedWidget = new LoginPage();
      } else {
        _displayedWidget = new Homepage();
      }
    });
  }
}

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData(
    brightness: Brightness.light,
    accentColorBrightness: Brightness.dark,
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    toggleableActiveColor: const Color(0xFF1E88E5),
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
      fontFamily: 'GoogleSans',
    ),
  );
}
