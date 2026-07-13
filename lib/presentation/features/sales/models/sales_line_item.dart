<<<<<<< HEAD

import 'package:supermarket/data/datasources/local/app_database.dart';
=======
import 'package:supermarket/data/datasources/local/app_database.dart';

>>>>>>> 2d430f8439a4d864f3ca3b6e9d35a290d925fd86
class SalesLineItem {
  Product? product;
  double quantity;
  double price;
  String selectedUnit;
  double discount;
  double unitFactor;
  String? costCenterId;

  SalesLineItem({
    this.product,
    this.quantity = 1,
    this.price = 0,
    this.selectedUnit = '',
    this.discount = 0,
    this.unitFactor = 1,
    this.costCenterId,
  });

  double get lineTotal => quantity * price;
}
