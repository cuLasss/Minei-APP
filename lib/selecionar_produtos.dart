import 'package:flutter/material.dart';

import 'mapa_preço.dart';


class SelectProductScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onProductsSelected;
  final List<Map<String, dynamic>> existingProducts; // Para edição

  const SelectProductScreen({
    super.key,
    required this.onProductsSelected,
    required this.existingProducts,
  });

  @override
  SelectProductScreenState createState() => SelectProductScreenState();
}

class SelectProductScreenState extends State<SelectProductScreen> {
  late List<Map<String, dynamic>> _availableProducts;

  @override
  void initState() {
    super.initState();
    _initializeAvailableProducts();
    _initializeQuantities();
  }

  void _initializeAvailableProducts() {
    _availableProducts = PriceMap.prices.entries.map((entry) {
      return {
        'product': entry.key,
        'price': entry.value.values.reduce((a, b) => a < b ? a : b), // Obtém o menor preço
        'quantity': 0,
      };
    }).toList();
  }

  void _initializeQuantities() {
    for (var product in widget.existingProducts) {
      final productName = product['product'];
      final quantity = product['quantity'];
      final index =
          _availableProducts.indexWhere((p) => p['product'] == productName);
      if (index != -1) {
        _availableProducts[index]['quantity'] = quantity;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Produtos'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.builder(
        itemCount: _availableProducts.length,
        itemBuilder: (context, index) {
          final product = _availableProducts[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(product['product']),
              subtitle:
                  Text('Preço: R\$ ${product['price'].toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      _updateQuantity(index, -1);
                    },
                  ),
                  Text('${product['quantity']}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _updateQuantity(index, 1);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final selectedProducts =
                _availableProducts.where((p) => p['quantity'] > 0).toList();

            // Verifica se há produtos selecionados antes de voltar
            if (selectedProducts.isNotEmpty) {
              widget.onProductsSelected(selectedProducts);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione pelo menos um produto.'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          child: const Text(
            'Adicionar Produtos Selecionados',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final product = _availableProducts[index];
      product['quantity'] = (product['quantity'] + change).clamp(0, 999);
    });
  }
}