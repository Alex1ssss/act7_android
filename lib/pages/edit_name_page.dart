import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/firebase_services.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idCategoriaController = TextEditingController();
  final TextEditingController nombreCategoriaController = TextEditingController();
  final TextEditingController aniosActivoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  DateTime? selectedDate;

  late String uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    uid = arguments['uid'];
    idCategoriaController.text = arguments['id_categoria'].toString();
    nombreCategoriaController.text = arguments['nombre_categoria'];
    aniosActivoController.text = arguments['anios_activo'].toString();
    descripcionController.text = arguments['descripcion_categoria'];
    selectedDate = arguments['fecha_creacion'].toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar categoría", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: idCategoriaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "ID de categoría"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  if (int.tryParse(value) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              TextFormField(
                controller: nombreCategoriaController,
                decoration: const InputDecoration(labelText: "Nombre de categoría"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: aniosActivoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "anios activo"),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo obligatorio';
                  if (int.tryParse(value) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null
                    ? "Seleccionar fecha de creación"
                    : "Fecha: ${selectedDate!.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && selectedDate != null) {
                    await updateCategoria(
                      uid: uid,
                      idCategoria: int.parse(idCategoriaController.text),
                      nombreCategoria: nombreCategoriaController.text.trim(),
                      aniosActivo: int.parse(aniosActivoController.text),
                      descripcionCategoria: descripcionController.text.trim(),
                      fechaCreacion: Timestamp.fromDate(selectedDate!),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
