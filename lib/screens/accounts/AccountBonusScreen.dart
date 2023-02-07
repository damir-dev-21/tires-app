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

class AccountBonusScreen extends StatefulWidget {
  const AccountBonusScreen({Key? key}) : super(key: key);

  @override
  State<AccountBonusScreen> createState() => _AccountBonusScreenState();
}

class _AccountBonusScreenState extends State<AccountBonusScreen> {
  final TextEditingController _controllerDateEnd = TextEditingController();
  final TextEditingController _controllerDateBegin = TextEditingController();
  late DateTime _selectedDateBegin = DateTime.now().subtract(Duration(days: 1));
  late DateTime _selectedDateEnd = DateTime.now();
  bool isLoad = false;

  late BalanceDataSource balanceDataSource;

  Future<void> _selectDateBegin(
      BuildContext context, String client_uuid) async {
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
      await context.read<BalanceProvider>().getAccountBonus(
          DateFormat("dd.MM.yyyy").format(_selectedDateBegin),
          DateFormat("dd.MM.yyyy").format(_selectedDateEnd),
          client_uuid);
    }
  }

  Future<void> _selectDateEnd(BuildContext context, String client_uuid) async {
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
      await context.read<BalanceProvider>().getAccountBonus(
          DateFormat("dd.MM.yyyy").format(_selectedDateBegin),
          DateFormat("dd.MM.yyyy").format(_selectedDateEnd),
          client_uuid);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    void openFile() async {
      try {
        setState(() {
          isLoad = true;
        });
        final file = balanceProvider.accountBonusFile;
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
        title: Text(langs[authProvider.langIndex]['account_bonus']),
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
                          await cartProvider.showAllClient(context);
                          _selectDateBegin(
                            context,
                            cartProvider.client['uuid_customer'],
                          );
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
                          await cartProvider.showAllClient(context);
                          _selectDateEnd(
                            context,
                            cartProvider.client['uuid_customer'],
                          );
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
              child: balanceProvider.isLoad
                  ? Center(
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
                                  name: 'limit',
                                  columnName: 'limit',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'planPay',
                                  columnName: 'planPay',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'factPay',
                                  columnName: 'factPay',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'payWithBack',
                                  columnName: 'payWithBack',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'payRemind',
                                  columnName: 'payRemind',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'remindDispatch',
                                  columnName: 'remindDispatch',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'done',
                                  columnName: 'done',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'dispatch',
                                  columnName: 'dispatch',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'days',
                                  columnName: 'days',
                                  summaryType: GridSummaryType.sum),
                            ],
                            position: GridTableSummaryRowPosition.bottom),
                      ],
                      source: BalanceDataSource(
                          balance:
                              context.read<BalanceProvider>().balanceDetail),
                      columns: [
                        GridColumn(
                            columnName: 'client',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Контрагент',
                                ))),
                        GridColumn(
                            columnName: 'limit',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Лимит',
                                ))),
                        GridColumn(
                            columnName: 'planPay',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Оплата план',
                                ))),
                        GridColumn(
                            columnName: 'factPay',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Оплата факт',
                                ))),
                        GridColumn(
                            columnName: 'payWithBack',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Оплата с возврат',
                                ))),
                        GridColumn(
                            columnName: 'payRemind',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Оплата остаток',
                                ))),
                        GridColumn(
                            columnName: 'remindDispatch',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Остаток отгрузка',
                                ))),
                        GridColumn(
                            columnName: 'done',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Выполнено',
                                ))),
                        GridColumn(
                            columnName: 'dispatch',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Отгружено',
                                ))),
                        GridColumn(
                            columnName: 'days',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Дни',
                                ))),
                      ]),
            ),
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
              DataGridCell<String>(
                  columnName: 'client', value: e['Контрагент']),
              // DataGridCell<String>(
              //     columnName: 'registrator', value: e.registrator),
              DataGridCell<int>(columnName: 'limit', value: e['Лимит']),
              DataGridCell<int>(columnName: 'planPay', value: e['ОплатаПлан']),
              DataGridCell<int>(columnName: 'factPay', value: e['ОплатаФакт']),
              DataGridCell<int>(
                  columnName: 'payWithBack', value: e['ОплатаСВозврат']),
              DataGridCell<int>(
                  columnName: 'payRemind', value: e['ОплатаОстаток']),
              DataGridCell<int>(
                  columnName: 'remindDispatch', value: e['ОстатокОтгрузка']),
              DataGridCell<int>(columnName: 'done', value: e['Вып']),
              DataGridCell<int>(columnName: 'dispatch', value: e['Отгр']),
              DataGridCell<int>(columnName: 'days', value: e['Дни']),
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
        alignment: (dataGridCell.columnName == 'client'
            ? Alignment.centerLeft
            : Alignment.center),
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
