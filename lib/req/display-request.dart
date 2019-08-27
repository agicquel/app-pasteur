import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lost_in_pasteur/model/display.dart';
import 'dart:convert';
import 'dart:async';

class DisplayRequest {
  static Future<List<Display>> fetchDisplay() async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http
          .get(await storage.read(key: 'api_url') + '/displays', headers: {
        'Accept': 'application/json',
        'x-access-token': await storage.read(key: 'jwt')
      });
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Display.fromJson(model)).toList();
      } else {
        throw Exception('Failed to load displays');
      }
    } catch (e) {
      print(e);
      return new Future<List<Display>>(null);
    }
  }

  static Future<bool> updateDisplay(Display display) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.put(
          await storage.read(key: 'api_url') +
              '/displays/' +
              display.id.toString(),
          headers: {
            'Accept': '*/*',
            'x-access-token': await storage.read(key: 'jwt')
          },
          body: display.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> removeDisplay(Display display) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.delete(
        await storage.read(key: 'api_url') +
            '/displays/' +
            display.id.toString(),
        headers: {
          'Accept': '*/*',
          'x-access-token': await storage.read(key: 'jwt')
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> declareDisplay(String espId) async {
    print("declare");
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.get(
          await storage.read(key: 'api_url') + '/displays/declare/' + espId,
          headers: {
            'Accept': '*/*',
            'x-access-token': await storage.read(key: 'jwt')
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> getRenameLopy(String ssid) async {
    try {
      final storage = new FlutterSecureStorage();
      var sanitizer = new HtmlEscape();
      final response = await http.get(await storage.read(key: 'api_url') +
          '/rename/' +
          sanitizer.convert(ssid));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
