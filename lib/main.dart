import "package:flutter/material.dart";
import 'package:currency_conversor/Config.dart';
import "package:http/http.dart" as http;
import "package:async/async.dart";
import "dart:convert";

const request = "https://api.hgbrasil.com/finance?key=${Config.apiKey}";



Future<void> main() async {
  Uri uri = Uri.parse(request);
  http.Response response = await http.get(uri);
  print(json.decode(response.body)["results"]["currencies"]["USD"]);

  runApp(MaterialApp(
    home: Container(),
  ));
}