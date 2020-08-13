import 'package:flutter/material.dart';
List getMazos(){
  return List.from([
    "Mazo1",
    "Mazo2",
    "Mazo3",
    "Mazo4",
    "Mazo5",
  ]);
}

List<Widget> mapMazos(){
  List m = getMazos();
  List<Widget> w = m.map((nombreMazo) => ListTile(title: Text(nombreMazo))).toList();
  return w;
}
void main(){
  var l = mapMazos();
  print(l);
}

