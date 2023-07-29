import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/CreditSimulationController.dart';
import 'creditoSimulation.dart';
import 'showtables.dart';

class AmortizationTablePage extends StatelessWidget {
  Future<void> _saveTableToFirestore(context) async {
    // Asegúrate de haber inicializado Firebase antes de usar Firestore

// Obtén una instancia de FirebaseAuth
    final FirebaseAuth _auth = FirebaseAuth.instance;

// Obtén el usuario actualmente autenticado
    User? user = _auth.currentUser;

// Verifica si el usuario está autenticado y obtén el UID si es así
    String userId = '';
    if (user != null) {
      userId = user.uid;
      print('User ID: $userId');
    } else {
      print('Usuario no autenticado.');
    }

    // Crea una referencia a la colección "users" y el documento usando el ID del usuario
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference userDocument = usersCollection.doc(userId);

    // Convierte la tabla de cotizaciones en un mapa para almacenarla en Firestore
    List<Map<String, dynamic>> tableData =
        _controller.amortizationTable.map((entry) {
      return {
        'Cuota': 'Cuota ${entry.monthNumber}',
        'Saldo Inicial': entry.initialBalance.toStringAsFixed(2),
        'Valor de Cuota': entry.monthlyPayment.toStringAsFixed(2),
        'Interés': entry.interest.toStringAsFixed(2),
        'Abono al Capital': entry.principalPayment.toStringAsFixed(2),
        'Saldo del Período': entry.finalBalance.toStringAsFixed(2),
      };
    }).toList();

    // Guarda la tabla en Firestore
    await userDocument.set({'cotizaciones': tableData});

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Guardado Completado'),
        content: Text(
            'La tabla de amortización se ha guardado en Firestore correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  final CreditSimulationController _controller =
      Get.find<CreditSimulationController>();

  Future<void> _requestStoragePermission() async {
    // You can request multiple permissions here if needed.
    var status = await Permission.storage.request();

    if (status.isGranted) {
      // Permission granted.
      // You can proceed with saving files or performing other actions that require storage access.
    } else if (status.isDenied) {
      // Permission denied.
      // You can show a message or take appropriate action to handle the denied permission.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied.
      // You should show a custom dialog to explain why the permission is required and provide a button to open the app settings page.
    }
  }

  Future<void> _exportToCSV(BuildContext context) async {
    List<List<dynamic>> rows = [
      [
        'Cuota',
        'Saldo Inicial',
        'Valor de Cuota',
        'Interés',
        'Abono al Capital',
        'Saldo del Período',
      ]
    ];

    for (var entry in _controller.amortizationTable) {
      rows.add([
        entry.monthNumber,
        entry.initialBalance.toStringAsFixed(2),
        entry.monthlyPayment.toStringAsFixed(2),
        entry.interest.toStringAsFixed(2),
        entry.principalPayment.toStringAsFixed(2),
        entry.finalBalance.toStringAsFixed(2),
      ]);
    }
    await _requestStoragePermission();
    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();

    final file = File('/storage/emulated/0/Download/amortization_table.csv');
    await file.writeAsString(csvData);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exportación Completada'),
        content: Text(
            'La tabla de amortización se ha exportado al directorio de Documentos correctamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcular la tabla de amortización al cargar la página

    return Scaffold(
      appBar: AppBar(title: Text('Tabla de Amortización')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Set vertical scrolling
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Set horizontal scrolling
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Cuota')),
                      DataColumn(label: Text('Saldo Inicial')),
                      DataColumn(label: Text('Valor de Cuota')),
                      DataColumn(label: Text('Interés')),
                      DataColumn(label: Text('Abono al Capital')),
                      DataColumn(label: Text('Saldo del Período')),
                    ],
                    rows: _controller.amortizationTable
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text('Cuota ${entry.monthNumber}')),
                              DataCell(Text(
                                  '\$${entry.initialBalance.toStringAsFixed(2)}')),
                              DataCell(Text(
                                  '\$${entry.monthlyPayment.toStringAsFixed(2)}')),
                              DataCell(Text(
                                  '\$${entry.interest.toStringAsFixed(2)}')),
                              DataCell(Text(
                                  '\$${entry.principalPayment.toStringAsFixed(2)}')),
                              DataCell(Text(
                                  '\$${entry.finalBalance.toStringAsFixed(2)}')),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para guardar la cotización en el historial de créditos
                // Por ejemplo, guardar la lista de amortización en Firebase Firestore.

                //sprint(_controller.amortizationTable[1].finalBalance);
                _exportToCSV(context);
              },
              child: Text('Guardar Cotización'),
            ),
            ElevatedButton(
              onPressed: () {
                // Llama a la función para guardar la tabla en Firestore
                _saveTableToFirestore(context);
              },
              child: Text('Guardar Cotización en Firestore'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Get.to(CreditSimulationPage());
              },
            ),
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Get.to(SavedTablesPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
