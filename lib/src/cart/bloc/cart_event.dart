import 'package:equatable/equatable.dart';

import '../../catalog/models/catalog_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends CartEvent {
  final Item item;
  const AddItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

class RemoveItemEvent extends CartEvent {
   final String itemId;
   const RemoveItemEvent({required this.itemId});

   @override
   List<Object> get props => [itemId];
}

class ChangeItemQuantityEvent extends CartEvent {
  final String itemId;
  final int quantity;
  const ChangeItemQuantityEvent({required this.itemId, required this.quantity});

  @override
  List<Object> get props => [itemId, quantity];
}

class ChangeItemDiscountEvent extends CartEvent {
  final String itemId;
  final double discount;
  const ChangeItemDiscountEvent({required this.itemId, required this.discount});
  @override
  List<Object> get props => [itemId, discount];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
  @override
  List<Object> get props => [];
}

class UndoCartEvent extends CartEvent {
  const UndoCartEvent();
  @override
  List<Object> get props => [];
}

class RedoCartEvent extends CartEvent {
  const RedoCartEvent();
  @override
  List<Object> get props => [];
}

class GenerateReceipt extends CartEvent {
  const GenerateReceipt();
  @override
  List<Object> get props => [];
}