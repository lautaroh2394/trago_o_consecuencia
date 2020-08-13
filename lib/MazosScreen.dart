import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MazoEditScreen.dart';
import 'MazoModel.dart';

class MazosScreen extends StatefulWidget{
  static String route = "/MazosScreen";
  @override
  State<StatefulWidget> createState() => _MazosScreenState();
}

class _MazosScreenState extends State<MazosScreen>{

  void navigateTo(ruta,{args = ""}) => Navigator.pushNamed(context, ruta, arguments: args);
  final BoxDecoration defaultButtonDeco = BoxDecoration(
    color: Colors.deepPurpleAccent,
    borderRadius: const BorderRadius.all(const Radius.circular(20)),
  );

  Widget crearOpcion(nombreMazo, ruta){
    return Container(
      decoration: defaultButtonDeco,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Center(
          child: Row(
            children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(nombreMazo,
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
                onTap: ()=>{MazoCollectionModel.getInstance().select(nombreMazo)},
                //child: Icon(Icons.check,color: (MazoCollectionModel.getInstance().selected?.nombre) == nombreMazo ? Colors.green : Colors.grey,)
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.check,color: (MazoCollectionModel.getInstance().selected?.nombre) == nombreMazo ? Colors.green : Colors.grey,),
                )
            ),
            GestureDetector(
                onTap: ()=>{this.navigateTo(ruta,args: MazoCollectionModel.getInstance().get(nombreMazo))},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.border_color),
                )
            )
            ],
          ),
        )
    );
  }

  List getMazos(){
    return MazoCollectionModel.getInstance().mazosNombres;
  }

  List<Widget> mazosAsWidgetList(){
    //TODO: Quizás usar directamente los mazos instanciados en vez de nombres.
    return getMazos().map((nombreMazo) => crearOpcion(nombreMazo, MazoEditScreen.route)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de mazos"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => navigateTo(MazoEditScreen.route, args: MazoCollectionModel.getInstance().nuevoMazo()),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ChangeNotifierProvider.value(
                value: MazoCollectionModel.getInstance(),
                child: Consumer<MazoCollectionModel>(
                  builder: (context, _, child){
                    return ListView(
                      children: mazosAsWidgetList(),
                    );
                  },
                )
              ),
            )
          ],
        )
    );
  }
}