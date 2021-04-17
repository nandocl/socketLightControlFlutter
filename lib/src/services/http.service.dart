import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/user.model.dart';
import '../models/light.model.dart';
import '../vars/localVars.dart' as vars;

//Users

Future<UserItemModel> login({String userLogin, String passwordLogin}) async {
  var user = new UserItemModel();
  var response = await http
      .post(Uri.http(vars.backendUrl, '/login'),
          headers: vars.headers,
          body: convert.jsonEncode(
              <String, dynamic>{'user': userLogin, 'password': passwordLogin}))
      .timeout(Duration(seconds: 5), onTimeout: () {
    return null;
  });
  if (response == null) return null;
  if (response.statusCode == 200) {
    var jsonResponde = convert.jsonDecode(response.body);
    user = UserItemModel.fromJson(jsonResponde);
    return user;
  }
  return null;
}

Future<UserItemModel> loginWithToken(String token) async {
  var user = new UserItemModel();
  var response = await http
      .post(Uri.http(vars.backendUrl, '/loginWithToken'),
          headers: vars.headers,
          body: convert.jsonEncode(<String, dynamic>{'token': token}))
      .catchError((onError) {
    return null;
  }).timeout(Duration(seconds: 5), onTimeout: () {
    return null;
  });
  if (response == null) return null;
  if (response.statusCode == 200) {
    var jsonResponde = convert.jsonDecode(response.body);
    user = UserItemModel.fromJson(jsonResponde);
    return user;
  } else {
    return null;
  }
}

Future<List<String>> mainMenu() async {
  List<String> menu = [];
  var response = await http.get(Uri.http(vars.backendUrl, '/getMenu'),
      headers: vars.headers);
  if (response.statusCode == 200) {
    List<dynamic> jsonResponde = convert.jsonDecode(response.body);
    menu = jsonResponde.map((item) => item.toString()).toList();
    return menu;
  } else {
    return null;
  }
}

//////Luz
//Get all luz items
Future<List<LuzModel>> getAllLuz() async {
  List<LuzModel> luzList = [];
  var response = await http.get(Uri.http(vars.backendUrl, '/getAllLuz'),
      headers: vars.headers);
  if (response.statusCode == 200) {
    List<dynamic> jsonResponde = convert.jsonDecode(response.body);
    luzList = jsonResponde.map((item) => LuzModel.fromJson(item)).toList();
    return luzList;
  } else {
    return null;
  }
}
