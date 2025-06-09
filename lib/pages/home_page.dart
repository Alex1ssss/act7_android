import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart'
    show deleteCategoria, getCategoria;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "📂 Categorías | Alexis Espino",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: getCategoria(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay categorías registradas.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                final fecha = item['fecha_creacion']?.toDate();
                final fechaTexto = fecha != null
                    ? "${fecha.day}/${fecha.month}/${fecha.year}"
                    : 'Sin fecha';

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Dismissible(
                    key: Key(item['uid']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("¿Eliminar ${item['nombre_categoria']}?"),
                          content: const Text("Esta acción no se puede deshacer."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Eliminar"),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) async {
                      await deleteCategoria(item['uid']);
                      setState(() {});
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.category, size: 40, color: Colors.pinkAccent),
                      title: Text(
                        item['nombre_categoria'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🆔 ID: ${item['id_categoria']}"),
                            Text("📅 Años Activo: ${item['anios_activo']}"),
                            Text("📝 Descripción: ${item['descripcion_categoria']}"),
                            Text("📆 Creado: $fechaTexto"),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          "/edit",
                          arguments: item,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        label: const Text("Agregar"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
