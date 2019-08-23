import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lost_in_pasteur/model/user.dart';
import 'dart:async';

import 'package:lost_in_pasteur/req/request-constant.dart';

class UserRequest {
  static Future<bool> registerAndAuthUser(
      String login, String mail, String password) async {
    try {
      final response = await http.post(
          ConstantRequest.fullUrl + '/users/register',
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'login': login,
            'email': mail,
            'password': password
          });

      if (response.statusCode == 200) {
        return authenticateUser(login, password);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> authenticateUser(String login, String password) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.post(
          ConstantRequest.fullUrl + '/users/authenticate',
          headers: {
            'Accept': '*/*',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'login': login,
            'password': password
          });

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        if (res['data']['token'] != null) {
          await storage.write(key: 'jwt', value: res['data']['token']);
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> updateUser(User user) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.put(
          ConstantRequest.fullUrl + '/users/' + user.id.toString(),
          headers: {
            'Accept': '*/*',
            'x-access-token': await storage.read(key: 'jwt')
          },
          body: user.toJson());

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

  static Future<bool> removeUser(User user) async {
    try {
      final storage = new FlutterSecureStorage();
      final response = await http.delete(
        ConstantRequest.fullUrl + '/users/' + user.id.toString(),
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
}
