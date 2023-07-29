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

                // Assuming you have properties 'meses' and 'saldoInicial' in your document.
                final meses = tableData['meses'];
                final saldoInicial = tableData['saldoInicial'];
                final interes = tableData['interes'];
                return Card(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Monto del crédito')),
                      DataColumn(label: Text('Cuotas')),
                      DataColumn(label: Text('Interés')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text(saldoInicial.toStringAsFixed(2))),
                          DataCell(Text(meses.toString())),
                          DataCell(Text(interes.toString())),
                        ],
                      ),
                    ],
                  ),
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
