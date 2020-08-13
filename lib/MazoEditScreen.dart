import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MazoModel.dart';

class MazoEditScreen extends StatefulWidget{
  static String route = "/MazoEditScreen";
  @override
  State<StatefulWidget> createState() => _MazoEditScreenState();
}

class _MazoEditScreenState extends State<MazoEditScreen>{

  _MazoEditScreenState(){
    nombreDelMazo = TextEditingController();
  }

  //final mazodummy = MazoCollectionModel.getInstance().nuevoMazo("mazo de prueba");

  Map<String, TextEditingController> controladores = {};
  void navigateTo(ruta) => Navigator.pushNamed(context, ruta);
  TextEditingController nombreDelMazo;
  //Mazo mazo;
  final BoxDecoration defaultButtonDeco = BoxDecoration(
    color: Colors.deepPurpleAccent,
    borderRadius: const BorderRadius.all(const Radius.circular(20)),
  );

  TextEditingController getControlador(Mazo mazo, String desafio){
    var original = controladores[desafio];
    if (original != null){
      return original;
    }
    else{
      TextEditingController nuevoControlador = TextEditingController();
      nuevoControlador.text = desafio;
      controladores[desafio] = nuevoControlador;
      return nuevoControlador;
    }
  }

  Widget desafioAsWidget(Mazo mazo, String desafio){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextField(
            controller: getControlador(mazo, desafio),
            //onChanged: (text) => mazo.actualizarDesafio(desafio, text), //TODO: Cada vez que se escribe se sobreescribe con el mismo contenido, moviendo el cursor al inicio.
          ),
        ),
        GestureDetector(
          onTap: ()=> mazo.eliminarDesafio(desafio),
          child: Icon(Icons.delete),
        )
      ],
    );
  }

  List<Widget> desafiosAsWidgetList(Mazo mazo){
    List<Widget> rta = [];
    mazo.desafios.forEach((element) {rta.add(desafioAsWidget(mazo,element));});
    return rta;
    //return desafios.map((desafio) => desafioAsWidget(desafio)).toList();
  }

  Widget mazoView(Mazo mazo){
    return Column(
      children: <Widget>[
        TextField(
            controller: nombreDelMazo..text = mazo.nombre,
            /*
          onChanged: (text) => {
            mazo.guardar(text)
          },
          */
          ),
        /*
        Container(
          decoration: BoxDecoration(border: Border(
          bottom: BorderSide(
              color: MazoCollectionModel.getInstance().repetido(nombreDelMazo.text) ? Colors.red : Colors.green
          )
          )),
          child: Consumer<Mazo>(
            builder: (context, _, __){
              return TextField(
                controller: nombreDelMazo..text = mazo.nombre,
                /*
                    onChanged: (text) => {
                      mazo.guardar(text)
                    },
                    */
                );
            },
          )
        ),*/
        Expanded(
          flex: 1,
          child: Consumer<Mazo>(
            builder: (context, _, child){
              return ListView(
              children: desafiosAsWidgetList(mazo),
              );
            }
          )
        )
      ],
    );
  }

  void guardar(context, mazo){
    if (MazoCollectionModel.getInstance().repetido(nombreDelMazo.text)){
      //Es nombre repetido.
      print("repetido");
      //TODO:fix
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No pueden haber mazos con el mismo nombre"),));
      return;
    }
    mazo.nombre = nombreDelMazo.text;
    mazo.guardar(mazo.nombre);
    controladores.forEach((key, value) {
      mazo.actualizarDesafio(key, value.text);
    });

    print(mazo.desafios);
    MazoCollectionModel.getInstance().notificar();
    print(MazoCollectionModel.getInstance().mazosNombres);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Mazo mazo = ModalRoute.of(context).settings.arguments;
    return ChangeNotifierProvider.value(
        value: mazo,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("${mazo.nombre}"),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: ()=> {guardar(context,mazo)}
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: ()=>{
                  mazo.agregarDesafio()
                },
              )
            ],
          ),
          backgroundColor: Colors.deepPurple,
          body: WillPopScope(
            // ignore: missing_return
            onWillPop: (){
              //Equivalente a clickear guardar.
              guardar(context,mazo);
            },
            child: mazoView(mazo),
        ),
      ),
    );
  }
}