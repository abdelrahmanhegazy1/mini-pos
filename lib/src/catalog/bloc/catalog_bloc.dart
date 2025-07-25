import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:pos_task/src/catalog/bloc/catalog_event.dart';

import '../models/catalog_item.dart';
import 'catalog_state.dart';

typedef CatalogLoader = Future<String> Function();

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogLoader catalogLoader;
  CatalogBloc({CatalogLoader? loader})
      : catalogLoader = loader ?? (() => rootBundle.loadString('assets/catalog.json')),
        super(CatalogLoading()) {
    on<CatalogLoadEvent>((event,emit)async{
      emit(CatalogLoading()); 
      try {
        final items = await getItems();
        emit(CatalogLoaded(items: items));
      }
      catch(e){
        emit(CatalogError(error: 'Failed to load catalog $e and ${e.toString()}}'));
      }
    });
  }

  Future<List<Item>> getItems() async {
    final catalogJson = await catalogLoader();
    final List<dynamic> catalogList = jsonDecode(catalogJson);
    return catalogList.map((item) => Item.fromJson(item)).toList();
  }
}

