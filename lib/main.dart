import "dart:async";
import "package:flutter/material.dart";
import 'package:currency_conversor/Config.dart';
import "package:http/http.dart" as http;
import "dart:convert";

const request = "https://api.hgbrasil.com/finance?key=${Config.apiKey}";

Future<void> main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

Future<Map> getData() async {
  Uri uri = Uri.parse(request);
  http.Response response = await http.get(uri);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: Text("\$ Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{
                return Container(color: Colors.green,);
              }
          }
        },
      ),
    );
  }
}
