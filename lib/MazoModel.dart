import 'dart:convert';

import 'package:flutter/widgets.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trago_o_consecuencia/FileManager.dart';
//import 'dart:convert';

class MazoCollectionModel extends ChangeNotifier{
  static MazoCollectionModel _instance = null;
  Mazo selected;
  List<String> get mazosNombres => _mazosInstanciados.map((e) => e.nombre).toList();
  String _mazoElegido;
  List<Mazo> _mazosInstanciados = [];
  SharedPreferences _sp;
  SharedPreferences get sp => _sp;

  static MazoCollectionModel getInstance(){
    if (_instance == null){
      _instance = MazoCollectionModel();
    }
    return _instance;
  }

  Future<void> init() async{
    _sp = await SharedPreferences.getInstance();
    print("Cargando mazos...");
    List<dynamic> files = _sp.getStringList("MazosJSONS");
    await Future.forEach(files, (fileName) async {
      try{
        var jsondata = await FileManager.LoadContentAsJson(fileName);
        Mazo m = Mazo(jsondata["nombre"],desafios:jsondata["desafios"]);
        _mazosInstanciados.add(m);
      }
      catch(err){
        print("Error al cargar mazo ${fileName}; Error: $err");
      }
    });
    print("Mazos cargados: ${_mazosInstanciados.map((e) => e.nombre).toList().toString()}");
    //TODO: Verificar que el mazo seleccionado exista y esté instanciado. Si no existe, cambiarlo al primero de la lista
  }

  void notificar(){
    notifyListeners();
  }

  Mazo get(String nombre){
    num pos = _mazosInstanciados.indexWhere((element) => element.nombre == nombre);
    if (pos > -1) { return _mazosInstanciados[pos]; }
    return null;
  }

  Mazo nuevoMazo(){
    String nuevoNombre = "Nuevo mazo";
    Mazo m = get(nuevoNombre);
    num n = 1;
    while (m != null){
      m = get(nuevoNombre + "$n");
      n++;
    }
    m = Mazo(nuevoNombre);
    _mazosInstanciados.add(m);
    notifyListeners();
    return m;
  }

  void deleteMazo(nombre){
    num pos = _mazosInstanciados.indexWhere((element) => element.nombre == nombre);
    if (pos == -1){ print("No existe el mazo"); return;}
    _mazosInstanciados.removeAt(pos);
    FileManager.Delete(fileName: nombre);
    notifyListeners();
  }

  void select(String mazo){
    selected = get(mazo);
    _sp.setString("MazoElegido", mazo);
    notifyListeners();
  }

  bool repetido(string){
    return mazosNombres.where((element) => element == string).toList().length > 1;
  }

  void resetAll() async{
    print("resetall");
    _mazosInstanciados.toList().forEach((mazo) { deleteMazo(mazo.nombre);});
    await _sp.setBool("firstTime", true);
    (await DefaultCreator.getAllFilePaths()).forEach((path) async{
      print("deleting $path");
      if (path.contains(DefaultCreator.NAMEEXT)){
        await FileManager.Delete(path: path);
      }
    });
  }
}

class Mazo extends ChangeNotifier{
  List<dynamic> desafios = [];
  List<String> _desafiosActualizados = [];

  String nombre;

  Mazo(nombre,{desafios = Null}){
    this.nombre = nombre;
    this.desafios = (desafios != Null) ? desafios : [];
  }

  void guardar(nombre) async {
    var nomAnterior = this.nombre;
    if (this.nombre != nombre){
      this.nombre = nombre;
    }
    String _nombre = await FileManager.Save(this,nomAnterior); //TODO: Manejar error
    //TODO: MEJORAR CODIGO
    var _sp = await SharedPreferences.getInstance();
    List<dynamic> files = _sp.getStringList("MazosJSONS");
    files.add(_nombre);
    _sp.setStringList("MazosJSONS", files);
    notifyListeners();
  }

  bool cargar(){
    //TODO: Cargar archivo json
    return true;
  }

  num find(String d){
    return desafios.indexWhere((element) => element == d);
  }

  bool agregarDesafio(){
    var nombre = "Nuevo desafio";
    num n = 1;
    while (find(nombre + "$n") != -1){
      n++;
    }
    nombre = nombre + "$n";
    desafios.add(nombre);
    notifyListeners();
    return true;
  }

  bool eliminarDesafio(String d) {
    var pos = find(d);
    if (pos != -1) {
      desafios.removeAt(pos);
      notifyListeners();
      return true;
    }
    print("No existe ese nombre");
    return false;
  }

  void actualizarDesafio(String original, String nuevo){
    var pos = find(original);
    if (pos>-1){
      desafios[pos] = nuevo;
    }
    else{
      //TODO: En realidad no sería posible que cayera en esta casuistica, o sí?
    }
    notifyListeners();
  }

  @override
  String toString(){
    return json.encode({
      "nombre":this.nombre,
      "desafios": this.desafios
    });
  }
}