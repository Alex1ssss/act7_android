import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getCategoria() async {
  List categoria = [];
  CollectionReference collectionReferenceCategoria = db.collection("categoria");
  QuerySnapshot queryCategoria = await collectionReferenceCategoria.get();
  for (var doc in queryCategoria.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final item = {
      'uid': doc.id,
      'id_categoria': data['id_categoria'],
      'nombre_categoria': data['nombre_categoria'],
      'anios_activo': data['anios_activo'],
      'descripcion_categoria': data['descripcion_categoria'],
      'fecha_creacion': data['fecha_creacion'],
    };
    categoria.add(item);
  }

  return categoria;
}

Future<void> addCategoria({
  required int idCategoria,
  required String nombreCategoria,
  required int aniosActivo,
  required String descripcionCategoria,
  required Timestamp fechaCreacion,
}) async {
  await db.collection("categoria").add({
    'id_categoria': idCategoria,
    'nombre_categoria': nombreCategoria,
    'anios_activo': aniosActivo,
    'descripcion_categoria': descripcionCategoria,
    'fecha_creacion': fechaCreacion,
  });
}

Future<void> updateCategoria({
  required String uid,
  required int idCategoria,
  required String nombreCategoria,
  required int aniosActivo,
  required String descripcionCategoria,
  required Timestamp fechaCreacion,
}) async {
  await db.collection('categoria').doc(uid).set({
    'id_categoria': idCategoria,
    'nombre_categoria': nombreCategoria,
    'anios_activo': aniosActivo,
    'descripcion_categoria': descripcionCategoria,
    'fecha_creacion': fechaCreacion,
  });
}

Future<void> deleteCategoria(String uid) async {
  await db.collection('categoria').doc(uid).delete();
}
