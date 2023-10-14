
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

GridColumn column(
    {required String columnName,
      String? labelName,
      bool allowSorting = false,
      bool allowFiltering = false,
      bool allowEditing = false,
      double width = double.nan}) {
  return GridColumn(
    width: width,
    allowSorting: allowSorting,
    allowFiltering: allowFiltering,
    allowEditing: allowEditing,
    autoFitPadding: const EdgeInsets.all(20),
    filterIconPadding: EdgeInsets.zero,
    // columnWidthMode: ColumnWidthMode.none,

    columnName: columnName,
    sortIconPosition: ColumnHeaderIconPosition.end,
    label: allowFiltering||allowSorting? Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: Text(
        labelName ?? columnName,
        overflow: TextOverflow.ellipsis,
      ),
    ):Align(
      alignment: Alignment.center,
      child: Text(
        labelName ?? columnName,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
