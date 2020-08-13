import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trago_o_consecuencia/FileCreators.dart';
import 'ArchivosIniciales.dart';
import 'dart:io';
import 'dart:convert';

class MazoCollectionModel extends ChangeNotifier{
  static MazoCollectionModel _instance = null;
  Mazo selected;
  List<String> get mazosNombres => _mazosInstanciados.map((e) => e.nombre).toList();
  String _mazoElegido;
  List<Mazo> _mazosInstanciados = [];
  /*
  List<Mazo> _mazosInstanciados = [
    Mazo("Mazo1", desafios: ["desafio1","desafio2"]),
    Mazo("Mazo2", desafios: ["desafio3","desafio4"]),
  ];
  */
  SharedPreferences _sp;

  static MazoCollectionModel getInstance(){
    if (_instance == null){
      _instance = MazoCollectionModel();
    }
    return _instance;
  }

  Future<void> init() async{
    _sp = await SharedPreferences.getInstance();
    //TODO: Instanciar mazos
  }
  void notificar(){
    notifyListeners();
  }

  SharedPreferences get sp => _sp;

  void cargarMazos() async{
    print("Cargando mazos...");
    final directory = await getApplicationDocumentsDirectory();
    List<String> files = _sp.get("MazosJSONS");
    files.forEach((fileName) async {
      File file = await File('${directory.path}/$fileName');
      String jsonstring = await file.readAsString();
      var jsondata = json.decode(jsonstring);
      Mazo m = Mazo(jsondata["nombre"],desafios:jsondata["desafios"]);
      _mazosInstanciados.add(m);
      //Instanciar mazo desde el json {fileName} y agregarlo a _mazosInstanciados
    });
    print("Mazos cargados: ${_mazosInstanciados.map((e) => e.nombre).toList().toString()}");
    //Verificar que el mazo seleccionado exista y esté instanciado. Si no existe, cambiarlo al primero de la lista
  }

  Future crearArchivo(jsondata) async{
    var jsonstring = jsondata.toString();
    var filename = jsondata["nombre"] + ".json";
    final directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/$filename');
    await file.writeAsString(jsondata);
    return filename;
  }

  List<String> getFileNames(){
    //TODO: Mover logica de generacion de nombre a DefaultCreator
    return _mazosInstanciados.map((Mazo m) => m.nombre + ".json").toList();
  }

  Mazo get(String nombre){
    num pos = _mazosInstanciados.indexWhere((element) => element.nombre == nombre);
    if (pos > -1) { return _mazosInstanciados[pos]; }
    //TODO Contemplar caso que no existe
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
    notifyListeners();
  }

  void select(String mazo){
    selected = get(mazo);
    _sp.setString("MazoElegido", mazo);
    notifyListeners();
  }

  bool repetido(string){
    return mazosNombres.where((element) => element == string).toList().length > 0;
  }

  void resetAll() async{
    print("resetall");
    _mazosInstanciados.forEach((mazo) { deleteMazo(mazo.nombre);});
    await _sp.setBool("firstTime", false);
    (await DefaultCreator.getAllFilePaths()).forEach((path) async{
      if (path.contains(DefaultCreator.NAMEEXT)){
        print("borrando $path");
        await (await File(path)).delete();
      }
    });
  }
}

class Mazo extends ChangeNotifier{
  List<String> desafios = [];
  List<String> _desafiosActualizados = [];

  String nombre;

  Mazo(nombre,{desafios = Null}){
    this.nombre = nombre;
    this.desafios = (desafios != Null) ? desafios : [];
  }

  void guardar(nombre){
    if (this.nombre != nombre){
      this.nombre = nombre;
    }

    /*
    TODO: crear archivo Json con la estructura:
    {
      nombre: this.nombre,
      desafios: this.desafios
    }
     */
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
}