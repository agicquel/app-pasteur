import 'package:http/http.dart' as http;
import 'package:lost_in_pasteur/model/display.dart';
import 'dart:convert';
import 'dart:async';

import 'package:lost_in_pasteur/req/request-constant.dart';

class DisplayRequest {

  static Future<List<Display>> fetchDisplay() async {
    final response = await http.get(ConstantRequest.fullUrl + '/displays', headers: {'Accept': 'application/json', 'x-api-key' : ConstantRequest.apiKey});

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Display.fromJson(model)).toList();
    }
    else {
      throw Exception('Failed to load displays');
    }
  }

  static Future<bool> updateDisplay(Display display) async {
    final response = await http.put(
      ConstantRequest.fullUrl + '/displays/' + display.id.toString(),
      headers: {'Accept': '*/*', 'x-api-key' : ConstantRequest.apiKey},
      body: display.toJson()
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  static Future<bool> removeDisplay(Display display) async {
    final response = await http.delete(
        ConstantRequest.fullUrl + '/displays/' + display.id.toString(),
        headers: {'Accept': '*/*', 'x-api-key' : ConstantRequest.apiKey},
    );

    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

}