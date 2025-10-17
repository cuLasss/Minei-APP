import 'package:flutter/material.dart';

import 'comparison_screen.dart';
import 'criar_lista_compras.dart';
import 'mapa_preço.dart';
import 'selecionar_produtos.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<Map<String, dynamic>> _shoppingLists = []; // Listas de compras

  double _calculateListTotal(Map<String, dynamic> shoppingList) {
    double total = 0.0;
    final products = shoppingList['products'] ?? [];

    for (var product in products) {
      final price = product['price'] ?? 0.0;
      final quantity = product['quantity'] ?? 0;
      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas de Compras'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateShoppingListScreen(
                    onListCreated: _addShoppingList,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _shoppingLists.isEmpty
          ? const Center(
              child: Text(
                'Você ainda não criou uma lista de compras.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _shoppingLists.length,
              itemBuilder: (context, index) {
                final shoppingList = _shoppingLists[index];
                final total = _calculateListTotal(shoppingList);

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shoppingList['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingListDetailScreen(
                            shoppingList: shoppingList,
                            onListUpdated: _updateShoppingList,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  void _addShoppingList(Map<String, dynamic> shoppingList) {
    setState(() {
      _shoppingLists.add(shoppingList);
    });
  }

  void _updateShoppingList(Map<String, dynamic> updatedList) {
    setState(() {
      final index = _shoppingLists.indexWhere((list) => list['name'] == updatedList['name']);
      if (index != -1) {
        _shoppingLists[index] = updatedList;
      }
    });
  }
}

class ShoppingListDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shoppingList;
  final Function(Map<String, dynamic>) onListUpdated;

  const ShoppingListDetailScreen({
    super.key,
    required this.shoppingList,
    required this.onListUpdated,
  });

  @override
  ShoppingListDetailScreenState createState() => ShoppingListDetailScreenState();
}

class ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final products = widget.shoppingList['products'];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList['name']),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _renameList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addProduct();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(product['product']),
              subtitle: Text('Preço: R\$ ${product['price']}'),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComparisonScreen(
                      shoppingList: widget.shoppingList['products'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: const Text(
                'Comparar Preços',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: R\$ ${_calculateTotal(widget.shoppingList['products']).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final product = widget.shoppingList['products'][index];
      product['quantity'] = (product['quantity'] + change).clamp(0, 999);
      widget.onListUpdated(widget.shoppingList);
    });
  }

  double _calculateTotal(List<Map<String, dynamic>> products) {
    return products.fold(0.0, (total, product) {
      final price = product['price'] ?? 0;
      final quantity = product['quantity'] ?? 0;
      return total + (price * quantity);
    });
  }

  void _renameList() {
    TextEditingController controller = TextEditingController(text: widget.shoppingList['name']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renomear Lista'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Novo nome da lista'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.shoppingList['name'] = controller.text;
                  widget.onListUpdated(widget.shoppingList);
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectProductScreen(
          onProductsSelected: (newProducts) {
            setState(() {
              for (var newProduct in newProducts) {
                // Verifica se o produto já existe na lista
                final existingProduct = widget.shoppingList['products'].firstWhere(
                  (prod) => prod['product'] == newProduct['product'],
                  orElse: () => {
                    'product': '',
                    'price': PriceMap.prices[newProduct['product']]?.values.reduce((a, b) => a < b ? a : b) ?? 0.0,
                    'quantity': 0
                  },
                );

                if (existingProduct['product'] != '') {
                  existingProduct['quantity'] += newProduct['quantity'];
                } else {
                  // Se não existir, adiciona o novo produto à lista
                  widget.shoppingList['products'].add({
                    'product': newProduct['product'],
                    'price': PriceMap.prices[newProduct['product']]?.values.reduce((a, b) => a < b ? a : b) ?? 0.0,
                    'quantity': newProduct['quantity']
                  });
                }
              }
              widget.onListUpdated(widget.shoppingList);
            });
          },
          existingProducts: [],
        ),
      ),
    );
  }
}