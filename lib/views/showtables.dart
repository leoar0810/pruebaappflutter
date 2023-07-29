import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedTablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tablas Guardadas'),
      ),
      body: _buildSavedTablesList(),
    );
  }

  Widget _buildSavedTablesList() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user == null) {
      return Center(
        child: Text('Usuario no autenticado.'),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cotizaciones')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            final tables = snapshot.data!.docs;

            if (tables.isEmpty) {
              return Center(
                child: Text('No se encontraron tablas guardadas.'),
              );
            }

            return ListView.builder(
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final tableData = tables[index].data() as Map<String, dynamic>;
                // Aquí puedes mostrar los datos de la tabla, como su nombre o información relevante.
                // Por ejemplo, si tienes una propiedad 'name' en tu documento de tabla:
                // final tableName = tableData['name'];
                return ListTile(
                    // title: Text(tableName),
                    // Mostrar otros datos relevantes de la tabla aquí.
                    );
              },
            );
          }

          return Center(
            child: Text('Ocurrió un error al obtener los datos.'),
          );
        },
      );
    }
  }
}
