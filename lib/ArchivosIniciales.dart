import 'package:trago_o_consecuencia/MazoModel.dart';

class ArchivosIniciales {
  static List mazosDefault = [
    {
      "nombre": "default",
      "desafios":[
        "Hacé la vertical por 5 segundos",
        "Hacé 20 flexiones de brazo en menos de 30 segundos",
        "Pensá en un nro del 1 al 10. Si alguno de los presentes acierta, bebés",
        "Piedra, papel o tijera con la persona al lado tuyo. Si perdés, bebés"
      ]
    },
  ];

  static void generar() async {
    List<String> jsons = [];
    mazosDefault.forEach((descriptor) async{
      String nombre = await (MazoCollectionModel.getInstance().crearArchivo(descriptor));
      jsons.add(nombre);
    });

    List<String> mazosJsons = MazoCollectionModel.getInstance().sp.getStringList("MazosJSONS") ?? [];
    jsons.forEach((nombreArchivo) {mazosJsons.add(nombreArchivo);});
    MazoCollectionModel.getInstance().sp.setStringList("MazosJSONS", mazosJsons);
    MazoCollectionModel.getInstance().sp.setString("MazoElegido", mazosDefault[0].nombre);
  }
}