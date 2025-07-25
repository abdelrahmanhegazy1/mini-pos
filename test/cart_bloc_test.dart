import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_task/src/cart/bloc/cart_bloc.dart';
import 'package:pos_task/src/cart/bloc/cart_event.dart';
import 'package:pos_task/src/cart/bloc/cart_state.dart';
import 'package:pos_task/src/catalog/models/catalog_item.dart';
import 'package:pos_task/src/extensions/money_ext.dart';

void main() {
  blocTest<CartBloc, CartState>(
    '1- Two Different Items --> Correct Totals',
    build: () => CartBloc(),
    act: (bloc) => 
      bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
      add(const AddItemEvent(item: Item(id: 'p02', name: 'Bagel', price: 3.20))),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      // That is mean the grandTotal for the first item is 2.875 and the grandTotal for the first item + second item is 6.555
      isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal', 2.875),
      isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal', 6.555)
    ],
  );

  blocTest<CartBloc, CartState>(
    '2- Quantity Changes and Discounts Changes --> Update Totals',
    build: () => CartBloc(),
    act: (bloc) => 
    bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
    add(const ChangeItemQuantityEvent(itemId: "p01", quantity: 3))..
    add(const ChangeItemDiscountEvent(itemId: "p01", discount: 50)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      //isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal', 6.225),
      isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal After Adding Item', 2.875),
      isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal After Changing Quantity', 8.625),
      isA<CartState>().having((state) => state.totals.grandTotal, 'grandTotal After Changing Discount', 4.3125),
    ],
  );
  
  blocTest<CartBloc, CartState>(
    '3- Clearing cart resets state.',
    build: () => CartBloc(),
    act: (bloc) => 
    bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
   add(const AddItemEvent(item: Item(id: 'p02', name: 'Bagel', price: 3.20)))..
   add(const ChangeItemQuantityEvent(itemId: "p01", quantity: 4))..
   add(const ClearCartEvent()),

   expect: () => [
    isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Coffee',2.875),
    isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Bagel', 6.555),
    isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Changing The Quantity of Coffee to 4', 15.18),
    isA<CartState>().having((state)=> state.lines.length, 'the items in the cart After Clearing all items',0)
   ]

  );

  blocTest<CartBloc, CartState>(
    '4- Undo Items Experience After Adding two items and clicking to undo twice',
    build: ()=> CartBloc(),
    act: (bloc)=> 
    bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
    add(const AddItemEvent(item: Item(id: 'p02', name: 'Bagel', price: 3.20)))..
    add(const UndoCartEvent())..
    add(const UndoCartEvent()),
    expect: () => [
      isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Coffee',2.875),
      isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Bagel', 6.555),
      isA<CartState>().having((state)=> state.lines.length, 'the length of items after making first undo', 1),
      isA<CartState>().having((state)=> state.lines.length, 'the length of items after making second undo', 0)
    ]
  );

  blocTest<CartBloc, CartState>(
    '5- Redo Item after using undo',
    build: ()=> CartBloc(),
    act: (bloc)=> 
    bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
    add(const UndoCartEvent())..
    add(const RedoCartEvent()),
    expect: () => [
      isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Coffee',2.875),
      isA<CartState>().having((state)=> state.lines.length, 'the length of items after making undo', 0),
      isA<CartState>().having((state)=> state.lines.length, 'the length of items after making redo', 1)
    ]
  );

  blocTest<CartBloc,CartState>(
    '6- Test asMoney extension to format the number in 2 digits after .',
    build: ()=> CartBloc(),
    act: (bloc) => 
     bloc.add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.54646))),
    expect: ()=>[
      isA<CartState>().having((state)=>state.totals.grandTotal.asMoney, 'grandTotal After adding converting it to money format', "2.93")
    ]
  );

  blocTest<CartBloc,CartState>(
    '7- Generate Receipt for 2 items after buying it',
    build: ()=>CartBloc(),
    act: (bloc) =>
    bloc..add(const AddItemEvent(item: Item(id: 'p01', name: 'Coffee', price: 2.50)))..
    add(const AddItemEvent(item: Item(id: 'p02', name: 'Bagel', price: 3.20)))..
    add(const GenerateReceipt()),
    expect: ()=>[
      isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Coffee',2.875),
      isA<CartState>().having((state)=> state.totals.grandTotal, 'grandTotal After Adding A Bagel', 6.555),
      isA<CartCheckedOutState>().having((state)=> state.receipt.totals.grandTotal, 'grandTotal After Adding A Bagel', 6.555),

    ]
  );
}
