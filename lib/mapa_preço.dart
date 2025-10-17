// price_map.dart
class PriceMap {
  // Mapa de preços onde a chave é o nome do produto e o valor é outro mapa com o preço por mercado
  static final Map<String, Map<String, double>> prices = {
    'Arroz': {
      'Supermercado A': 15.00,
      'Supermercado B': 14.50,
      'Supermercado C': 13.50,
    },
    'Feijão': {
      'Supermercado A': 8.00,
      'Supermercado B': 7.50,
      'Supermercado C': 6.80,
    },
    'Macarrão': {
      'Supermercado A': 5.00,
      'Supermercado B': 5.20,
      'Supermercado C': 4.80,
    },
    'Açúcar': {
      'Supermercado A': 4.50,
      'Supermercado B': 4.70,
      'Supermercado C': 4.30,
    },
    'Óleo': {
      'Supermercado A': 6.80,
      'Supermercado B': 7.00,
      'Supermercado C': 7.20,
    },
    'Sal': {
      'Supermercado A': 2.30,
      'Supermercado B': 2.50,
      'Supermercado C': 2.70,
    },
    'Leite': {
      'Supermercado A': 3.30,
      'Supermercado B': 3.50,
      'Supermercado C': 3.80,
    },
    'Ovo': {
      'Supermercado A': 0.45,
      'Supermercado B': 0.50,
      'Supermercado C': 0.55,
    },
    'Frango': {
      'Supermercado A': 10.00,
      'Supermercado B': 9.50,
      'Supermercado C': 10.50,
    },
    'Carne': {
      'Supermercado A': 30.00,
      'Supermercado B': 28.00,
      'Supermercado C': 32.00,
    },
    'Pão': {
      'Supermercado A': 3.00,
      'Supermercado B': 2.80,
      'Supermercado C': 3.20,
    },
    'Miojo': {
      'Supermercado A': 1.99,
      'Supermercado B': 0.50,
      'Supermercado C': 1.20,
    },
  };

  // Método para atualizar o preço de um produto em um mercado específico
  static void updatePrice(String product, String market, double newPrice) {
    if (prices.containsKey(product) && prices[product]!.containsKey(market)) {
      prices[product]![market] = newPrice;
    }
  }

  // Método para adicionar um novo produto
  static void addProduct(String product, Map<String, double> marketPrices) {
    prices[product] = marketPrices;
  }
}
