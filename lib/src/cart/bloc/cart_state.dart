import 'package:equatable/equatable.dart';

import '../models/cart_line.dart';
import '../models/totals.dart';

class CartState extends Equatable {
  
  final List<CartLine> lines;
  final Totals totals;
  const CartState({required this.lines, required this.totals});

  @override
  List<Object> get props => [lines, totals];
}

