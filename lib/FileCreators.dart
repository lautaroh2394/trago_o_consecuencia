import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trago_o_consecuencia/MazoModel.dart';
import 'HomeScreen.dart';
class Creator{
  static SharedPreferences _sp;
  static String NAMESTART = "trago_o_consecuencia";
  static String NAMEEXT = "json";
}
class DefaultCreator extends Creator{
  /*
  static SharedPreferences _sp;
  static String NAMESTART = "trago_o_consecuencia";
  static String NAMEEXT = "json";
   */
  static const defaultMazos = [
    {
      "nombre" : "Default",
      "desafios" : [
        "desafio 1 creado por default",
        "desafio 2 creado por default"
      ]
    },
    {
      "nombre" : "Default 2",
      "desafios" : [
        "desafio 3 creado por default",
        "desafio 4 creado por default"
      ]
    },
  ];

  static Future<bool> validatePath(String path) async{
    return (await FileSystemEntity.isFile(path) && path.contains(NAMESTART) && path.contains(NAMEEXT));
  }

  static Future<List<String>> getAllFilePaths() async{
    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory(directory.path);
    var listado = await dir.list(recursive: false).toList();
    List<String> files = [];
    listado.forEach((file) async {
        files.add(file.path);
    });
    return files;
  }

  static Future<List<String>> getFilePaths() async{
    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory(directory.path);
    var listado = await dir.list(recursive: false).toList();
    List<String> files = [];
    await Future.forEach(listado, (file) async {
      if (await validatePath(file.path)){
        files.add(file.path);
      }
    });
    return files;
  }

  static void createDefaults() async{
    print("create defaults");
    final directory = await getApplicationDocumentsDirectory();
    List<String> mazosJsonsNames = [];
    await Future.forEach(defaultMazos, (mazo) async{
      String name = "${NAMESTART}_${mazo["nombre"]}.${NAMEEXT}";
      print("creando $name");
      File f = File("${directory.path}/$name");
      await f.create();
      await f.writeAsString(mazo.toString());
      print("Creado: $name");
      mazosJsonsNames.add(name);
    });
    _sp.setStringList("MazosJSONS",mazosJsonsNames);
  }

  static Future<void> checkSaved(BuildContext context) async {
    _sp = await SharedPreferences.getInstance();
    bool firstTime = _sp.getBool("firstTime");
    print("$firstTime");
    if (  firstTime == null || firstTime == false ){
      createDefaults();
      await _sp.setBool("firstTime", false);
    }
    print(await getFilePaths());
  }
}