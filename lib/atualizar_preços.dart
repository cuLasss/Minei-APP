import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mapa_preço.dart';
 // Importe a classe de formatação de moeda

class ChangePriceScreen extends StatefulWidget {
  const ChangePriceScreen({super.key});

  @override
  ChangePriceScreenState createState() => ChangePriceScreenState();
}

class ChangePriceScreenState extends State<ChangePriceScreen> {
  String? _selectedProduct;
  String? _selectedMarket;
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = 'R\$ 0,00'; // Inicializa com "R$ 0,00"
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _updatePrice() {
    String priceText = _priceController.text.replaceAll('R\$ ', '').replaceAll(',', '');
    if (priceText.isNotEmpty) {
      double priceValue = double.parse(priceText) / 100; // Converte para o formato correto
      PriceMap.updatePrice(_selectedProduct!, _selectedMarket!, priceValue);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preço atualizado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  bool _isButtonEnabled() {
    return _selectedProduct != null && _selectedMarket != null;
  }

  String _formatPrice(String value) {
    // Formata para R$ 00,00
    if (value.isEmpty) {
      return 'R\$ 0,00';
    }

    int parsedValue = int.tryParse(value) ?? 0;
    return 'R\$ ${((parsedValue / 100).toStringAsFixed(2)).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Preço'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Selecione um Produto',
                border: OutlineInputBorder(),
              ),
              value: _selectedProduct,
              items: PriceMap.prices.keys.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                  _selectedMarket = null; // Resetar o mercado selecionado
                  _priceController.text = 'R\$ 0,00'; // Limpa o campo de preço
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedProduct != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Selecione um Mercado',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMarket,
                items: PriceMap.prices[_selectedProduct]!.keys.map((market) {
                  return DropdownMenuItem(
                    value: market,
                    child: Text(market),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMarket = value;
                  });
                },
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Novo Preço',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                // Remove a formatação R$ e mantém apenas os dígitos
                String newValue = value.replaceAll('R\$ ', '').replaceAll(',', '');

                // Atualiza o campo com a formatação correta
                _priceController.text = _formatPrice(newValue);

                // Ajusta a posição do cursor ao final
                _priceController.selection = TextSelection.fromPosition(TextPosition(offset: _priceController.text.length));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled() ? _updatePrice : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Atualizar Preço',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}