import "dart:async";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:currency_conversor/Config.dart';
import "package:flutter/widgets.dart";
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
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double dolar;
  late double euro;
  late double real;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double real = double.parse(text);1
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
                      const Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      buildTextField("Reais", "R\$", realController, _realChanged),
                      const Divider(
                        color: Colors.white,
                      ),
                      buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                      const Divider(
                        color: Colors.white,
                      ),
                      buildTextField("Euros", "€", euroController, _euroChanged),
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


Widget buildTextField(
    String label, String prefix, TextEditingController controller, void Function(String)? onChanged) {

  return TextField(
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle:  TextStyle(color: Colors.amber),
        border:  OutlineInputBorder(),
        prefixText: prefix),
    style:  TextStyle(color: Colors.amber,
        fontSize: 25),
    controller: controller,
    onChanged: onChanged,
  );
}
