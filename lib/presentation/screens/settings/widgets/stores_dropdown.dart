import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';

class StoreDropdown extends StatelessWidget {
  final List<StoresResponseEntity> stores;
  final StoresResponseEntity? selectedStore;
  final ValueChanged<StoresResponseEntity?> onChanged;

  const StoreDropdown({
    super.key,
    required this.stores,
    this.selectedStore,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<StoresResponseEntity>(
  items: (String filter, LoadProps? loadProps) {
    if (filter.isEmpty) return stores;
    return stores
        .where((s) => s.storeName.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  },
  itemAsString: (StoresResponseEntity s) => s.storeName,
  selectedItem: selectedStore,
  compareFn: (s1, s2) => s1.storeId == s2.storeId, // <--- aquí
  onChanged: onChanged,
  popupProps: PopupProps.menu(
    showSearchBox: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: 'Buscar tienda...',
        border: OutlineInputBorder(),
      ),
    ),
  ),
  decoratorProps: DropDownDecoratorProps(
    decoration: InputDecoration(
      labelText: 'Tienda',
      border: OutlineInputBorder(),
    ),
  ),
);

  }
}
