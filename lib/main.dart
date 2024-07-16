import "dart:async";
import "package:flutter/material.dart";
import 'package:currency_conversor/Config.dart';
import "package:http/http.dart" as http;
import "dart:convert";

const request = "https://api.hgbrasil.com/finance?key=${Config.apiKey}";

Future<void> main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
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
  late double dolar;
  late double euro;

  void _atualizarDados(Map data) {
    setState(() {
      ;
    });
  }

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
              } else {
                dolar = double.parse(snapshot.data!['results']['currencies']
                        ['USD']['buy']
                    .toString());
                euro = double.parse(snapshot.data!['results']['currencies']
                        ['EUR']['buy']
                    .toString());
                print(dolar);
                print(euro);

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "R\$"),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Dólares",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "US\$"),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Euros",
                            labelStyle: TextStyle(color: Colors.amber),
                            border: OutlineInputBorder(),
                            prefixText: "€"),
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
