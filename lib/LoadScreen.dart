import 'package:flutter/material.dart';
import 'package:trago_o_consecuencia/FileManager.dart';
import 'package:trago_o_consecuencia/MazoModel.dart';
import 'HomeScreen.dart';

class LoadScreen extends StatefulWidget{
  static String route = "/LoadScreen";
  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen>{
  @override
  void initState(){
    super.initState();
    MazoCollectionModel.getInstance(); //Inicializo
    loadMazos();
  }

  Future<void> loadMazos() async {
    await DefaultCreator.checkSaved(context);
    await (MazoCollectionModel.getInstance()).init();
    Navigator.pushNamed(context, HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: const BorderRadius.all(const Radius.circular(20)),
      ),
      child: Center(
        child: Icon(Icons.favorite_border), //Logo acá
      ),
    );
  }
}