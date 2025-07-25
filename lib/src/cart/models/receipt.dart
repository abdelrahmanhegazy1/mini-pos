import '../bloc/cart_state.dart';
import 'cart_line.dart';
import 'totals.dart';

class Receipt {
  final DateTime time;
  final List<CartLine> lines;
  final Totals totals;

  Receipt({
    required this.time,
    required this.lines,
    required this.totals,
  });
}

Receipt buildReceipt(CartState state, DateTime time) {
  return Receipt(
    time: time,
    lines: state.lines,
    totals: state.totals,
  );
}
