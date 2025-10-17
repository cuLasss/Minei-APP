import 'package:flutter/material.dart';

import 'mapa_preço.dart';


class PriceComparisonScreen extends StatefulWidget {
  const PriceComparisonScreen({super.key});

  @override
  PriceComparisonScreenState createState() => PriceComparisonScreenState();
}

class PriceComparisonScreenState extends State<PriceComparisonScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Preços'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            Expanded(child: _buildPriceComparison()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase(); // Atualiza a consulta de busca
        });
      },
      decoration: InputDecoration(
        labelText: 'Buscar item',
        suffixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPriceComparison() {
    // Use o PriceMap.prices em vez de _prices
    final filteredPrices = PriceMap.prices.entries
        .where((entry) => entry.key.toLowerCase().contains(_searchQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredPrices.length,
      itemBuilder: (context, index) {
        final productName = filteredPrices[index].key;
        final productPrices = filteredPrices[index].value;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productPrices.entries.map((entry) {
                return Text(
                    '${entry.key}: R\$ ${entry.value.toStringAsFixed(2)}');
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}