import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:pos_task/src/catalog/bloc/catalog_bloc.dart';
import 'package:pos_task/src/catalog/bloc/catalog_event.dart';
import 'package:pos_task/src/catalog/bloc/catalog_state.dart';

void main() {
  
  blocTest<CatalogBloc, CatalogState>(
    'CatalogBloc should emit CatalogLoaded when catalog is loaded',
    build: () => CatalogBloc(loader:()async => '''
      [
        { "id": "p01", "name": "Coffee", "price": 2.50 },
        { "id": "p02", "name": "Bagel", "price": 3.20 }
      ]
    '''),
    act: (bloc) => bloc.add(CatalogLoadEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [isA<CatalogLoading>(),isA<CatalogLoaded>().having((state) => state.items.length, 'items length', greaterThan(0))],
  );
}