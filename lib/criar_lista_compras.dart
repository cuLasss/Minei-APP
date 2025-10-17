import 'package:flutter/material.dart';

import 'mapa_preço.dart';


class CreateShoppingListScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onListCreated;

  const CreateShoppingListScreen({super.key, required this.onListCreated});

  @override
  CreateShoppingListScreenState createState() =>
      CreateShoppingListScreenState();
}

class CreateShoppingListScreenState extends State<CreateShoppingListScreen> {
  // Lista de produtos com preços correspondentes
  late List<Map<String, dynamic>> _products;

  String _listName = ''; // Nome da lista

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  void _initializeProducts() {
    _products = PriceMap.prices.entries.map((entry) {
      return {
        'product': entry.key,
        'price': entry.value.values.reduce((a, b) => a > b ? a : b), // Obtém o maior preço
        'quantity': 0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione os Produtos'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nome da Lista',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.orangeAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.orangeAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                _listName = value;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(product['product']),
                    subtitle: Text('Maior Preço Sugerido: R\$ ${product['price'].toStringAsFixed(2)}'),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                List<Map<String, dynamic>> selectedProducts =
                    _products.where((p) => p['quantity'] > 0).toList();

                if (_listName.isEmpty || selectedProducts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, insira um nome e selecione pelo menos um item.'),
                    ),
                  );
                  return;
                }

                widget.onListCreated(
                    {'name': _listName, 'products': selectedProducts});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Salvar Lista de Compras',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final product = _products[index];
      product['quantity'] = (product['quantity'] + change).clamp(0, 999);
    });
  }
}