import 'package:equatable/equatable.dart';

import '../../catalog/models/catalog_item.dart';

class CartLine extends Equatable {
  final Item item;
  final int quantity;
  final double discount;

  const CartLine({required this.item, required this.quantity, required this.discount});

  double get lineNet => item.price * quantity * (1 - discount / 100);
  
  @override
  List<Object?> get props => [item, quantity, discount];

  CartLine copyWith({
    Item? item,
    int? quantity,
    double? discount,
  }) {
    return CartLine(item: item ?? this.item, quantity: quantity ?? this.quantity, discount: discount ?? this.discount);
  }
  
}