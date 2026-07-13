<<<<<<< HEAD

import 'package:supermarket/data/datasources/local/app_database.dart';
=======
import 'package:supermarket/data/datasources/local/app_database.dart';

>>>>>>> 2d430f8439a4d864f3ca3b6e9d35a290d925fd86
class InventoryTransactionReport {
  final InventoryTransaction transaction;
  final Product product;
  final Warehouse? warehouse;

  InventoryTransactionReport({
    required this.transaction,
    required this.product,
    this.warehouse,
  });
}

class BatchReport {
  final ProductBatch batch;
  final Product product;
  final Warehouse? warehouse;

  BatchReport({required this.batch, required this.product, this.warehouse});
}
