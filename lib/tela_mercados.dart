import 'package:flutter/material.dart';

class MarketsScreen extends StatelessWidget {
  final List<Map<String, String>> markets = [
    {'name': 'Supermercado A', 'address': 'Rua Principal, 123'},
    {'name': 'Supermercado B', 'address': 'Avenida Central, 456'},
    {'name': 'Supermercado C', 'address': 'Praça das Flores, 789'},
  ];

  MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercados'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
        itemCount: markets.length,
        itemBuilder: (context, index) {
          final market = markets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.store, color: Colors.orangeAccent),
              title: Text(
                market['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(market['address']!),
              onTap: () {
                _showMarketAddress(
                    context, market['name']!, market['address']!);
              },
            ),
          );
        },
      ),
    );
  }

  void _showMarketAddress(BuildContext context, String name, String address) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Text('Endereço: $address'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
