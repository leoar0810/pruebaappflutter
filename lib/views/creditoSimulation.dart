import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'showtables.dart';

import '../controllers/CreditSimulationController.dart';
import 'creditTable.dart';

class CreditSimulationPage extends StatelessWidget {
  final CreditSimulationController _controller =
      Get.put(CreditSimulationController());
  final TextEditingController _loanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulación de Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _controller.selectedCreditType.value,
              items: [
                'Crédito Vehículo',
                'Crédito Vivienda',
                'Crédito de Libre Inversión'
              ]
                  .map((creditType) => DropdownMenuItem<String>(
                      value: creditType, child: Text(creditType)))
                  .toList(),
              onChanged: (value) {
                _controller.selectedCreditType.value = value ?? '';
              },
              decoration: InputDecoration(labelText: 'Tipo de Crédito'),
            ),
            SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _controller.baseSalary.value = double.tryParse(value) ?? 0.0;
                if (value.isEmpty) {
                  _loanController.text = '0';
                  _controller.baseSalary.value = 10;
                } else {
                  _loanController.text =
                      (double.tryParse(value)! * 7 / 0.15).toString();
                  _controller.loanAmount.value =
                      (double.tryParse(value)! * 7 / 0.15);
                }
              },
              decoration: InputDecoration(labelText: 'Salario Base'),
            ),
            SizedBox(height: 12),
            TextFormField(
              enabled: false,
              controller: _loanController,
              decoration: InputDecoration(labelText: 'Valor del Préstamo'),
            ),
            SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _controller.loanMonths.value = int.tryParse(value) ?? 0;
              },
              decoration:
                  InputDecoration(labelText: 'Número de Meses del Préstamo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes realizar la simulación del crédito y pasar los datos a la próxima página con GetX
                _controller.calculateAmortizationTable();
                Get.to(() => AmortizationTablePage());
              },
              child: Text('Simular Crédito'),
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
