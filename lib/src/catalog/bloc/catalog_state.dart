import 'package:equatable/equatable.dart';

import '../models/catalog_item.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Item> items;

  const CatalogLoaded({required this.items});

  @override
  List<Object> get props => [items];

}

class CatalogError extends CatalogState {
  final String error;

  const CatalogError({required this.error});

  @override
  List<Object> get props => [error];

}