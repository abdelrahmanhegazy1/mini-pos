import 'package:bloc/bloc.dart';

import '../models/cart_line.dart';
import '../models/receipt.dart';
import '../models/totals.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartState> _undoStack = [];
  final List<CartState> _redoStack = [];
  CartBloc() : super(const CartState(lines: [], totals: Totals(subtotal: 0, vat: 0, grandTotal: 0))) {
    on<AddItemEvent>(_onAddItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<ChangeItemQuantityEvent>(_onChangeItemQuantity);
    on<ChangeItemDiscountEvent>(_onChangeItemDiscount);
    on<ClearCartEvent>(_onClearCart);
    on<UndoCartEvent>(_onUndoCart);
    on<RedoCartEvent>(_onRedoCart);
    on<GenerateReceipt>(_onGenerateReceipt);
  }


  Totals _calculateTotals(List<CartLine> lines) {
    final subtotal = lines.fold(0.0, (sum, l) => sum + l.lineNet);
    final vat = subtotal * 0.15;
    final grandTotal = subtotal + vat;
    return Totals(subtotal: subtotal, vat: vat, grandTotal: grandTotal);
  }

  void _onAddItem(AddItemEvent event, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    final newLines = [...state.lines];
    final indexOfExistingCartLine = newLines.indexWhere((line) => line.item.id == event.item.id);
    if(indexOfExistingCartLine != -1){
      newLines[indexOfExistingCartLine] = newLines[indexOfExistingCartLine].copyWith(quantity: newLines[indexOfExistingCartLine].quantity + 1);
    }
    else{
      newLines.add(CartLine(item: event.item, quantity: 1, discount: 0));
    }
    emit(CartState(lines: newLines, totals: _calculateTotals(newLines)));
  }

  void _onRemoveItem(RemoveItemEvent event, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    final newLines = [...state.lines];
    newLines.removeWhere((line) => line.item.id == event.itemId);
    emit(CartState(lines: newLines, totals: _calculateTotals(newLines)));
  }
  
  void _onChangeItemDiscount(ChangeItemDiscountEvent event, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    final newLines = [...state.lines];
    final indexOfExistingCartLine = newLines.indexWhere((line) => line.item.id == event.itemId);
    if(indexOfExistingCartLine != -1){
      newLines[indexOfExistingCartLine] = newLines[indexOfExistingCartLine].copyWith(discount: event.discount);
    }
    emit(CartState(lines: newLines, totals: _calculateTotals(newLines)));
  }

  void _onChangeItemQuantity(ChangeItemQuantityEvent event, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    final newLines = [...state.lines];
    final indexOfExistingCartLine = newLines.indexWhere((line) => line.item.id == event.itemId);
    if(indexOfExistingCartLine != -1){
      newLines[indexOfExistingCartLine] = newLines[indexOfExistingCartLine].copyWith(quantity: event.quantity);
    }
    emit(CartState(lines: newLines, totals: _calculateTotals(newLines)));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    emit(const CartState(lines: [], totals: Totals(subtotal: 0, vat: 0, grandTotal: 0)));
  }

  void _onUndoCart(UndoCartEvent event , Emitter<CartState> emit) {
    if(_undoStack.isNotEmpty) {
      _redoStack.add(state);
      final previous = _undoStack.removeLast();
      emit(previous);
    }
  }

  void _onRedoCart(RedoCartEvent event , Emitter<CartState> emit) {
    if(_redoStack.isNotEmpty){
      _undoStack.add(state);
      final next = _redoStack.removeLast();
      emit(next);
    }
  }

  void _onGenerateReceipt(GenerateReceipt event , Emitter<CartState> emit) {
    final Receipt receipt = buildReceipt(state,DateTime.now());
    emit(CartCheckedOutState(lines: state.lines,totals: state.totals,receipt));
  }
  
}

