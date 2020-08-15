import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MazoModel.dart';

class FileManager{
  static SharedPreferences _sp;
  static String NAMESTART = "trago_o_consecuencia";
  static String NAMEEXT = "json";

  static Future<String> Create(name, path, content) async {
    String _name = "${NAMESTART}_$name.${NAMEEXT}";
    print("creando $_name");
    File f = File("$path/$_name");
    await f.create();
    await f.writeAsString(content);
    print("Creado: $_name");
    return _name;
  }

  static Future<String> Save(Mazo m, nombreAnterior)async{
    final directory = await getApplicationDocumentsDirectory();
    if (m.nombre != nombreAnterior){
      await Delete(fileName: nombreAnterior);
    }
    var cont = m.toString();
    print(cont);
    String name = await Create(m.nombre, directory.path, cont);
    return name;
  }

  static Future<void> Delete({fileName = null, path = null}) async {
    var _path;
    if (fileName != null){
      final directory = await getApplicationDocumentsDirectory();
      _path = "${directory.path}$fileName";
    }else{
      _path = path;
    }

    print("borrando $_path");
    try{
      await (File(_path)).delete();
      print("borrado $_path");
    }
    catch(err){
      print("error al borrar $_path; error: $err");
    }
  }

  static Future<dynamic> LoadContentAsJson(fileName) async{
    final directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/$fileName');
    String jsonstring = await file.readAsString();
    return json.decode(jsonstring);
  }
}

class DefaultCreator{
  static SharedPreferences _sp;
  static String NAMESTART = "trago_o_consecuencia";
  static String NAMEEXT = "json";
  static const List<dynamic> defaultMazos = [
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
  /*
  "Hacé la vertical por 5 segundos",
  "Hacé 20 flexiones de brazo en menos de 30 segundos",
  "Pensá en un nro del 1 al 10. Si alguno de los presentes acierta, bebés",
  "Piedra, papel o tijera con la persona al lado tuyo. Si perdés, bebés"
   */

  static Future<bool> validatePath(String path) async{
    return (await FileSystemEntity.isFile(path) && path.contains(NAMESTART) && path.contains(NAMEEXT));
  }

  static Future<List<String>> getAllFilePaths() async{
    /*
    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory(directory.path);
    var listado = await dir.list(recursive: false).toList();
    List<String> files = [];
    listado.forEach((file) async {
        files.add(file.path);
    });
    return files;
    */
    return getFilePaths(validationCallback: () async =>true);
  }

  static Future<List<String>> getFilePaths({validationCallback = validatePath}) async{
    final directory = await getApplicationDocumentsDirectory();
    var dir = Directory(directory.path);
    var listado = await dir.list(recursive: false).toList();
    List<String> files = [];
    await Future.forEach(listado, (file) async {
      //if (await validationCallback(file.path)){
      //if (await validatePath(file.path)){
      if (await FileSystemEntity.isFile(file.path)){
        files.add(file.path);
      }
    });
    return files;
  }

  static Future<void> createDefaults() async{
    print("create defaults");
    final directory = await getApplicationDocumentsDirectory();
    List<String> mazosJsonsNames = [];
    await Future.forEach(defaultMazos, (mazo) async{
      String name = await FileManager.Create(mazo["nombre"], directory.path, json.encode(mazo));
      mazosJsonsNames.add(name);
    });
    _sp.setStringList("MazosJSONS", mazosJsonsNames);
    _sp.setString("MazoElegido", mazosJsonsNames[0]);
    print(_sp.getStringList("MazosJSONS"));
  }

  static Future<void> checkSaved(BuildContext context) async {
    _sp = await SharedPreferences.getInstance();
    bool firstTime = _sp.getBool("firstTime");
    print("$firstTime");
    if (  firstTime == null || firstTime != false ){
      print("First time");
      await createDefaults();
      await _sp.setBool("firstTime", false);
    }
    print(await getFilePaths());
  }
}