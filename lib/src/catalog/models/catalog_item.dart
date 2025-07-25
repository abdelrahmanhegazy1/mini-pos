import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final double price;


  const Item({required this.id, required this.name, required this.price});
  
  @override
  List<Object?> get props => [id, name, price];

  @override
  bool? get stringify => true;

  Item copyWith({
    String? id,
    String? name,
    double? price,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
  
  
}