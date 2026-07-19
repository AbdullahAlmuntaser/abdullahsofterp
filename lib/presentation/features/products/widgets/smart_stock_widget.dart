import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/utils/stock_display_adapter.dart';

class SmartStockWidget extends StatelessWidget {
  final Product product;

  const SmartStockWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return FutureBuilder<String>(
      future: StockDisplayAdapter(db).formatProductStock(product),
      builder: (context, snapshot) {
        final formattedStock = snapshot.data ?? '...';

        return Text(
          formattedStock,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        );
      },
    );
  }
}
