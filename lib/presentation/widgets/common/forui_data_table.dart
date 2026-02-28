import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../../core/theme/forui_theme.dart';

/// A custom data table component built with forui primitives
/// Supports sorting, pagination, and row selection
class ForuiDataTable extends StatelessWidget {
  final List<ForuiDataColumn> columns;
  final List<ForuiDataRow> rows;
  final bool showCheckboxColumn;
  final void Function(bool?)? onSelectAll;
  final int? sortColumnIndex;
  final bool sortAscending;

  const ForuiDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showCheckboxColumn = false,
    this.onSelectAll,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 300,
          ),
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            columnWidths: _buildColumnWidths(),
            children: [
              _buildHeaderRow(),
              ...rows.map((row) => _buildDataRow(row)),
            ],
          ),
        ),
      ),
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    final widths = <int, TableColumnWidth>{};
    if (showCheckboxColumn) {
      widths[0] = const FixedColumnWidth(60);
    }
    return widths;
  }

  TableRow _buildHeaderRow() {
    final headerCells = <Widget>[];

    if (showCheckboxColumn) {
      headerCells.add(
        Container(
          padding: const EdgeInsets.all(16),
          color: ForuiThemeConfig.surfaceGreen.withValues(alpha: 0.3),
          alignment: Alignment.center,
          child: Checkbox(
            value: _isAllSelected(),
            onChanged: onSelectAll,
            activeColor: ForuiThemeConfig.primaryGreen,
          ),
        ),
      );
    }

    for (var i = 0; i < columns.length; i++) {
      final column = columns[i];
      headerCells.add(
        Container(
          padding: const EdgeInsets.all(16),
          color: ForuiThemeConfig.surfaceGreen.withValues(alpha: 0.3),
          child: column.onSort != null
              ? InkWell(
                  onTap: () => column.onSort!(i, sortColumnIndex == i ? !sortAscending : true),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: column.label),
                      if (sortColumnIndex == i) ...[
                        const SizedBox(width: 4),
                        Icon(
                          sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                          color: ForuiThemeConfig.primaryGreen,
                        ),
                      ],
                    ],
                  ),
                )
              : column.label,
        ),
      );
    }

    return TableRow(children: headerCells);
  }

  TableRow _buildDataRow(ForuiDataRow row) {
    final cells = <Widget>[];

    if (showCheckboxColumn) {
      cells.add(
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Checkbox(
            value: row.selected,
            onChanged: row.onSelectChanged,
            activeColor: ForuiThemeConfig.primaryGreen,
          ),
        ),
      );
    }

    for (final cell in row.cells) {
      cells.add(
        Container(
          padding: const EdgeInsets.all(16),
          child: cell.child,
        ),
      );
    }

    return TableRow(
      decoration: row.selected
          ? BoxDecoration(
              color: ForuiThemeConfig.surfaceGreen.withValues(alpha: 0.2),
            )
          : null,
      children: cells,
    );
  }

  bool _isAllSelected() {
    if (rows.isEmpty) return false;
    return rows.every((row) => row.selected);
  }
}

class ForuiDataColumn {
  final Widget label;
  final void Function(int columnIndex, bool ascending)? onSort;

  const ForuiDataColumn({
    required this.label,
    this.onSort,
  });
}

class ForuiDataRow {
  final List<ForuiDataCell> cells;
  final bool selected;
  final void Function(bool?)? onSelectChanged;

  const ForuiDataRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
  });
}

class ForuiDataCell {
  final Widget child;

  const ForuiDataCell({
    required this.child,
  });
}

/// Pagination controls for the data table
class ForuiDataTablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final int totalItems;
  final Function(int) onPageChanged;
  final Function(int)? onItemsPerPageChanged;

  const ForuiDataTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalItems,
    required this.onPageChanged,
    this.onItemsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final startItem = (currentPage - 1) * itemsPerPage + 1;
    final endItem = (currentPage * itemsPerPage > totalItems)
        ? totalItems
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Showing $startItem-$endItem of $totalItems items',
            style: const TextStyle(
              fontSize: 14,
              color: ForuiThemeConfig.textSecondary,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 16),
                SizedBox(width: 4),
                Text('Previous'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ...List.generate(
            totalPages > 5 ? 5 : totalPages,
            (index) {
              final pageNumber = _getPageNumber(index, currentPage, totalPages);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: pageNumber == currentPage
                    ? ElevatedButton(
                        onPressed: null,
                        child: Text('$pageNumber'),
                      )
                    : OutlinedButton(
                        onPressed: () => onPageChanged(pageNumber),
                        child: Text('$pageNumber'),
                      ),
              );
            },
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Next'),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getPageNumber(int index, int currentPage, int totalPages) {
    if (totalPages <= 5) return index + 1;

    if (currentPage <= 3) {
      return index + 1;
    } else if (currentPage >= totalPages - 2) {
      return totalPages - 4 + index;
    } else {
      return currentPage - 2 + index;
    }
  }
}
