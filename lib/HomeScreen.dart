import 'package:flutter/material.dart';
import 'package:trago_o_consecuencia/FileCreators.dart';
import 'package:trago_o_consecuencia/MazoModel.dart';

import 'GameScreen.dart';
import 'MazosScreen.dart';

class HomeScreen extends StatefulWidget{
  static String route = "/HomeScreen";
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  void navigateTo(ruta) => Navigator.pushNamed(context, ruta);

  final BoxDecoration defaultButtonDeco = BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius: const BorderRadius.all(const Radius.circular(20)),
    );

  Widget crearOpcion(texto, ruta){
    return GestureDetector(
        onTap: ()=>{this.navigateTo(ruta)},
        child: Center(
            child: Container(
              decoration: defaultButtonDeco,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                child: Center(
                  child: Text(texto,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            crearOpcion("Jugar", GameScreen.route),
            crearOpcion("Editar mazos", MazosScreen.route),
            GestureDetector(
                onTap: (){
                  MazoCollectionModel.getInstance().resetAll();
                },
                child: Center(
                    child: Container(
                      decoration: defaultButtonDeco,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(
                          child: Text("reset",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                )
            ),
            GestureDetector(
                onTap: ()async  {
                  print(await DefaultCreator.getFilePaths());
                },
                child: Center(
                    child: Container(
                      decoration: defaultButtonDeco,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Center(
                          child: Text("list all filepaths",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                )
            )
          ],
        )
    );
  }
}