import 'package:equatable/equatable.dart';
import 'package:pos_task/src/cart/models/receipt.dart';

import '../models/cart_line.dart';
import '../models/totals.dart';

class CartState extends Equatable {
  
  final List<CartLine> lines;
  final Totals totals;
  const CartState({required this.lines, required this.totals});

  @override
  List<Object> get props => [lines, totals];
}

class CartCheckedOutState extends CartState {
  final Receipt receipt;

  const CartCheckedOutState(this.receipt, {required super.lines, required super.totals});
  @override
  List<Object> get props => [receipt,lines,totals];
}

