import 'package:flutter/material.dart';

import 'mapa_preço.dart';

class ComparisonScreen extends StatefulWidget {
  final List<Map<String, dynamic>> shoppingList;

  const ComparisonScreen({super.key, required this.shoppingList});

  @override
  ComparisonScreenState createState() => ComparisonScreenState();
}

class ComparisonScreenState extends State<ComparisonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Preços'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildComparison(),
      ),
    );
  }

  Widget _buildComparison() {
    final totals = _calculateTotals();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparação de Preços:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: totals.length,
            itemBuilder: (context, index) {
              final entry = totals.entries.elementAt(index);
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: Text(
                    'Total: R\$ ${entry.value['total']?.toStringAsFixed(2) ?? '0.00'}\nDesconto: R\$ ${entry.value['discount']?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.store),
                  onTap: () {
                    _showDiscountDetails(entry.key);
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          child: const Text(
            'Voltar',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Map<String, Map<String, double>> _calculateTotals() {
    final totals = <String, Map<String, double>>{
      'Supermercado A': {'total': 0.0, 'discount': 0.0},
      'Supermercado B': {'total': 0.0, 'discount': 0.0},
      'Supermercado C': {'total': 0.0, 'discount': 0.0},
    };

    double totalOriginal = 0.0;

    for (var product in widget.shoppingList) {
      final productName = product['product'];
      final quantity = product['quantity'] ?? 0;

      if (PriceMap.prices.containsKey(productName)) {
        final productPrices = PriceMap.prices[productName]!;
        final maxPrice = productPrices.values.reduce((a, b) => a > b ? a : b);

        totalOriginal += maxPrice * quantity; // Usa o preço máximo

        for (var market in productPrices.keys) {
          totals[market]!['total'] = (totals[market]!['total'] ?? 0.0) +
              (productPrices[market]! * quantity);
        }
      }
    }

    for (var market in totals.keys) {
      totals[market]!['discount'] =
          totalOriginal - (totals[market]!['total'] ?? 0.0);
    }

    return totals;
  }

  void _showDiscountDetails(String supermarket) {
    final discountDetails = _calculateDiscountDetails(supermarket);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Descontos no $supermarket:',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: discountDetails.length,
                  itemBuilder: (context, index) {
                    final entry = discountDetails[index];
                    return ListTile(
                      title: Text(entry['product']),
                      subtitle: Text(
                        'Preço: R\$ ${entry['price']?.toStringAsFixed(2) ?? '0.00'}\nDesconto: R\$ ${entry['discount']?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      leading: const Icon(Icons.label),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _calculateDiscountDetails(String supermarket) {
    final discountDetails = <Map<String, dynamic>>[];

    for (var product in widget.shoppingList) {
      final productName = product['product'];
      final quantity = product['quantity'] ?? 0;

      if (PriceMap.prices.containsKey(productName)) {
        final productPrices = PriceMap.prices[productName]!;
        final maxPrice = productPrices.values.reduce((a, b) => a > b ? a : b); // Preço máximo

        final priceInSupermarket = productPrices[supermarket]! * quantity; // Preço no mercado
        final discount = (maxPrice * quantity) - priceInSupermarket; // Cálculo do desconto
        
        discountDetails.add({
          'product': productName,
          'price': maxPrice,
          'discount': discount > 0 ? discount : 0, // Não permitir desconto negativo
        });
      }
    }

    return discountDetails;
  }
}