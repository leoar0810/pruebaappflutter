import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditSimulationController extends GetxController {
  final RxString selectedCreditType = "Crédito Vehículo".obs;
  final RxDouble baseSalary = 0.0.obs;
  final RxDouble loanAmount = 0.0.obs;
  final RxInt loanMonths = 12.obs;
  RxList<AmortizationEntry> amortizationTable = <AmortizationEntry>[].obs;

  void calculateAmortizationTable() {
    print(loanAmount);
    double monthlyInterestRate = 0.015; // 1.5% de interés mensual
    double monthlyPayment = loanAmount.value *
        (monthlyInterestRate /
            (1 - pow(1 + monthlyInterestRate, -loanMonths.value)));
    double remainingPrincipal = loanAmount.value;

    amortizationTable.clear();
    for (int i = 1; i <= loanMonths.value; i++) {
      double interest = remainingPrincipal * monthlyInterestRate;
      double principalPayment = monthlyPayment - interest;
      remainingPrincipal -= principalPayment;

      amortizationTable.add(AmortizationEntry(
        monthNumber: i,
        initialBalance: remainingPrincipal + principalPayment,
        monthlyPayment: monthlyPayment,
        interest: interest,
        principalPayment: principalPayment,
        finalBalance: remainingPrincipal,
      ));
    }
  }
}

class AmortizationEntry {
  final int monthNumber;
  final double initialBalance;
  final double monthlyPayment;
  final double interest;
  final double principalPayment;
  final double finalBalance;

  AmortizationEntry({
    required this.monthNumber,
    required this.initialBalance,
    required this.monthlyPayment,
    required this.interest,
    required this.principalPayment,
    required this.finalBalance,
  });
}
