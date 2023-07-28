import 'package:flutter/material.dart';

class CreditSimulationPage extends StatefulWidget {
  @override
  _CreditSimulationPageState createState() => _CreditSimulationPageState();
}

class _CreditSimulationPageState extends State<CreditSimulationPage> {
  String _selectedCreditType = 'Inmobiliario';
  double _salaryBase = 0.0;
  int _numberOfMonths = 12;

  void _simulateLoan() {
    // Calcula el préstamo acorde al salario base
    double loanAmount = _salaryBase / 2;

    // Realiza cualquier lógica adicional que necesites con el préstamo calculado

    // Ejemplo: Mostrar un cuadro de diálogo con el resultado del cálculo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado de la simulación'),
        content: Text('Monto del préstamo: \$${loanAmount.toStringAsFixed(2)}'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Simulación de Crédito')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCreditType,
              onChanged: (value) {
                setState(() {
                  _selectedCreditType = value!;
                });
              },
              items: ['Inmobiliario', 'Vehículo', 'Educación']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Tipo de Crédito'),
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _salaryBase = double.tryParse(value) ?? 0.0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Salario Base'),
            ),
            SizedBox(height: 12),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _numberOfMonths = int.tryParse(value) ?? 12;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'A cuántos meses?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateLoan,
              child: Text('Simular'),
            ),
          ],
        ),
      ),
    );
  }
}
