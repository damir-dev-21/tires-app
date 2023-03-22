// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/services/languages.dart';

class CollationActDetailScreen extends StatefulWidget {
  const CollationActDetailScreen({Key? key}) : super(key: key);

  @override
  State<CollationActDetailScreen> createState() => _CollationActScreenState();
}

class _CollationActScreenState extends State<CollationActDetailScreen> {
  final TextEditingController _controllerDateEnd = TextEditingController();
  final TextEditingController _controllerDateBegin = TextEditingController();
  late DateTime _selectedDateBegin = DateTime.now().subtract(Duration(days: 1));
  late DateTime _selectedDateEnd = DateTime.now();

  bool isLoad = false;

  late BalanceDataSource balanceDataSource;

  Future<void> _selectDateBegin(BuildContext context, String id) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: _selectedDateBegin,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDateBegin) {
      setState(() {
        _selectedDateBegin = picked;
      });
      await context.read<BalanceProvider>().getBalanceDetail(
          DateFormat("dd.MM.yyyy").format(_selectedDateBegin),
          DateFormat("dd.MM.yyyy").format(_selectedDateEnd),
          id);
    }
  }

  Future<void> _selectDateEnd(BuildContext context, String id) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: _selectedDateEnd,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDateEnd) {
      setState(() {
        _selectedDateEnd = picked;
      });
      await context.read<BalanceProvider>().getBalanceDetail(
          DateFormat("dd.MM.yyyy").format(_selectedDateBegin),
          DateFormat("dd.MM.yyyy").format(_selectedDateEnd),
          id);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: true);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    void openFile() async {
      try {
        final file = balanceProvider.balanceDetailFile;
        if (file == null) return;

        await OpenFile.open(file.path);
      } catch (e) {
        print(e);
        throw e;
      } finally {
        setState(() {
          isLoad = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appColor,
        title: Text(langs[authProvider.langIndex]['akt_sverki_detail']),
        actions: [
          isLoad
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () {
                    openFile();
                  },
                  icon: Icon(Icons.download))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _controllerDateBegin,
                        // focusNode: _calFocusNode,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await cartProvider.showAllClient(
                              context, authProvider.user);
                          _selectDateBegin(
                              context, cartProvider.client['id_share']);
                        },
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        decoration: InputDecoration(
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.black),
                            labelText: DateFormat("dd.MM.yy")
                                .format(_selectedDateBegin),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 15,
                      height: 2,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _controllerDateEnd,
                        // focusNode: _calFocusNode,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await cartProvider.showAllClient(
                              context, authProvider.user);
                          _selectDateEnd(
                              context, cartProvider.client['id_share']);
                        },

                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            labelText:
                                DateFormat("dd.MM.yy").format(_selectedDateEnd),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: context.read<BalanceProvider>().isLoad
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: appColor,
                      ),
                    )
                  : SfDataGrid(
                      columnWidthMode: ColumnWidthMode.fill,
                      tableSummaryRows: [
                        GridTableSummaryRow(
                            showSummaryInRow: false,
                            title: 'Итог',
                            titleColumnSpan: 2,
                            columns: [
                              const GridSummaryColumn(
                                  name: 'countBeginDebet',
                                  columnName: 'countBeginDebet',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'sumBeginDebet',
                                  columnName: 'sumBeginDebet',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'turnoverDebet',
                                  columnName: 'turnoverDebet',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'sumTurnoverDebet',
                                  columnName: 'sumTurnoverDebet',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'turnoverCredit',
                                  columnName: 'turnoverCredit',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'sumTurnoverCredit',
                                  columnName: 'sumTurnoverCredit',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'countEndDebet',
                                  columnName: 'countEndDebet',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'sumCountEndDebet',
                                  columnName: 'sumCountEndDebet',
                                  summaryType: GridSummaryType.sum),
                            ],
                            position: GridTableSummaryRowPosition.bottom),
                      ],
                      source: BalanceDataSource(
                          balance:
                              context.read<BalanceProvider>().balanceDetail),
                      columns: [
                        GridColumn(
                            columnName: 'number',
                            width: 70,
                            autoFitPadding: const EdgeInsets.all(0),
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '№',
                                ))),
                        // GridColumn(
                        //     columnName: 'registrator',
                        //     autoFitPadding: const EdgeInsets.all(0),
                        //     label: Container(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           'Операция',
                        //         ))),
                        GridColumn(
                            columnName: 'good',
                            columnWidthMode: ColumnWidthMode.auto,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Товар',
                                ))),
                        GridColumn(
                            columnName: 'price',
                            columnWidthMode: ColumnWidthMode.fill,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Цена',
                                ))),
                        GridColumn(
                            columnName: 'countBeginDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 100,
                            label: Center(
                                child: Text(
                              'Кол-во нач остаток дебет',
                              textAlign: TextAlign.center,
                            ))),
                        GridColumn(
                            columnName: 'sumBeginDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 120,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Сумма нач Остаток Дт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'turnoverDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 80,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Кол-во оборот Дт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'sumTurnoverDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 90,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Сумма оборот Дт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'turnoverCredit',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 90,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Кол-во оборот Кт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'sumTurnoverCredit',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 90,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Сумма оборот Кт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'countEndDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 100,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Кол-во конечный остаток Дт',
                                  textAlign: TextAlign.center,
                                ))),
                        GridColumn(
                            columnName: 'sumCountEndDebet',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            width: 90,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Сумма конечный остаток Дт',
                                  textAlign: TextAlign.center,
                                ))),
                      ]),
            )
          ],
        ),
      ),
    );
  }
}

class BalanceDataSource extends DataGridSource {
  BalanceDataSource({required List<Map<String, dynamic>> balance}) {
    _employees = balance
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'number', value: e['Номер']),
              // DataGridCell<String>(
              //     columnName: 'registrator', value: e.registrator),
              DataGridCell<String>(columnName: 'good', value: e['Товар']),
              DataGridCell<int>(columnName: 'price', value: e['Цена']),
              DataGridCell<int>(
                  columnName: 'countBeginDebet',
                  value: e['КоличествоНачальныйОстатокДт']),
              DataGridCell<int>(
                  columnName: 'sumBeginDebet',
                  value: e['СуммаНачальныйОстатокДт']),
              DataGridCell<int>(
                  columnName: 'turnoverDebet', value: e['КоличествоОборотДт']),
              DataGridCell<int>(
                  columnName: 'sumTurnoverDebet', value: e['СуммаОборотДт']),
              DataGridCell<int>(
                  columnName: 'turnoverCredit', value: e['КоличествоОборотКт']),
              DataGridCell<int>(
                  columnName: 'sumTurnoverCredit', value: e['СуммаОборотКт']),
              DataGridCell<int>(
                  columnName: 'countEndDebet',
                  value: e['КоличествоКонечныйОстатокДт']),
              DataGridCell<int>(
                  columnName: 'sumCountEndDebet',
                  value: e['СуммаКонечныйОстатокДт']),
            ]))
        .toList();
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15.0),
        child: Text(summaryValue));
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        decoration: BoxDecoration(),
        width: 50,
        alignment: (dataGridCell.columnName == 'good'
            ? Alignment.centerLeft
            : Alignment.center),
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
