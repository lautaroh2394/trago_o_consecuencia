import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trago_o_consecuencia/MazoModel.dart';

class GameScreen extends StatefulWidget {
  static String route = "/GameScreen";
  //Main layout
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<dynamic> desafios = MazoCollectionModel.getInstance().selected.desafios;
  /*
  [
    "Hacé la vertical por 5 segundos",
    "Hacé 20 flexiones de brazo en menos de 30 segundos",
    "Pensá en un nro del 1 al 10. Si alguno de los presentes acierta, bebés",
    "Piedra, papel o tijera con la persona al lado tuyo. Si perdés, bebés"
  ];
   */

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