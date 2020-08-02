import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trago o consecuencia',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TragoConsecuenciaJuego(),
    );
  }
}

class TragoConsecuenciaJuego extends StatefulWidget {
  //Main layout
  @override
  _TragoConsecuenciaJuegoState createState() => _TragoConsecuenciaJuegoState();
}

class _TragoConsecuenciaJuegoState extends State<TragoConsecuenciaJuego> {
  final List<String> desafios = [
    "Hacé la vertical por 5 segundos",
    "Hacé 20 flexiones de brazo en menos de 30 segundos",
    "Pensá en un nro del 1 al 10. Si alguno de los presentes acierta, bebés",
    "Piedra, papel o tijera con la persona al lado tuyo. Si perdés, bebés"
  ];
  
  String desafioActual;
  final _randomizador = Random();
  String getRandomDesafio() => desafios.elementAt(_randomizador.nextInt(desafios.length));

  void sonidoTrago(){
    //todo
  }
  void sonidoFalla(){
    //todo
  }

  void _updateChallenge([acepta = false]) {
    var nextDesafio = getRandomDesafio();
    while (nextDesafio == desafioActual){
      nextDesafio = getRandomDesafio();
    }

    acepta? sonidoTrago() : sonidoFalla();

    setState(() {
      desafioActual = nextDesafio;
    });
  }

  BoxDecoration deco([color= Colors.blue]){
    return BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.all(const Radius.circular(20)),
    );
  }

  @override
  Widget build(BuildContext context) {


    var topContainer = Expanded(
      flex: 3,
      child: Container(
        decoration: deco(),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Center(
          child: Text(
            desafioActual ?? getRandomDesafio(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      )
    );

    var bottomContainer = Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: ()=>{_updateChallenge(true)},
        child: Container(
          decoration: deco(Colors.green),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Center(
            child: Text("Ok!!",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    var footerContainer = Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: ()=>{_updateChallenge(false)},
        child: Container(
          decoration: deco(Colors.red),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: GestureDetector(
            child: Center(
              child: Text("Próximo",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      )
    );

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Column(
          children: <Widget>[
            topContainer,
            bottomContainer,
            footerContainer,
            ],
          )
        );
    }
}
