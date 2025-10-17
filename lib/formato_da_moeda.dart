import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove qualquer caractere que não seja dígito
    final onlyDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Converte a string de dígitos em um número
    double value = double.tryParse(onlyDigits) ?? 0.0;

    // Formata o número como moeda
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final formattedValue = formatter.format(value / 100); // Divide por 100 para centavos

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}