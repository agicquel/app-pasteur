import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lost_in_pasteur/model/lopy.dart';
import 'dart:convert';
import 'dart:async';

class LopyRequest {
  static Future<List<Lopy>> fetchLopy() async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http
          .get(await storage.read(key: 'api_url') + '/lopys', headers: {
        'Accept': 'application/json',
        'x-access-token': await storage.read(key: 'jwt')
      });
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return list.map((model) => Lopy.fromJson(model)).toList();
      } else {
        throw Exception('Failed to load lopys');
      }
    } catch (e) {
      print(e);
      return new Future<List<Lopy>>(null);
    }
  }

  static Future<Lopy> getLopy(String mac) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http
          .get(await storage.read(key: 'api_url') + '/lopys/' + mac, headers: {
        'Accept': 'application/json',
        'x-access-token': await storage.read(key: 'jwt')
      });
      if (response.statusCode == 200) {
        return Lopy.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load lopys');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}