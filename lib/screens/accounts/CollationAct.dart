// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/balance.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/services/languages.dart';

class CollationActScreen extends StatefulWidget {
  const CollationActScreen({Key? key}) : super(key: key);

  @override
  State<CollationActScreen> createState() => _CollationActScreenState();
}

class _CollationActScreenState extends State<CollationActScreen> {
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
      await context.read<BalanceProvider>().getBalance(
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
      await context.read<BalanceProvider>().getBalance(
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
        final file = balanceProvider.balanceFile;
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
        title: Text(langs[authProvider.langIndex]['akt_sverki']),
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
                              context, cartProvider.client['uuid_customer']);
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
                              context, cartProvider.client['uuid_customer']);
                          print(cartProvider.client);
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Начальный остаток",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                        balanceProvider.initial_balance['debet'].toString()),
                  ),
                  Text(balanceProvider.initial_balance['credit'].toString()),
                ],
              ),
            ),
            SizedBox(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: context.read<BalanceProvider>().isLoad
                  ? Center(
                      child: CircularProgressIndicator(
                        color: appColor,
                      ),
                    )
                  : SfDataGrid(
                      columnWidthMode: ColumnWidthMode.fitByCellValue,
                      tableSummaryRows: [
                        GridTableSummaryRow(
                            showSummaryInRow: false,
                            title: 'Итог',
                            titleColumnSpan: 2,
                            columns: [
                              const GridSummaryColumn(
                                  name: 'debit',
                                  columnName: 'debit',
                                  summaryType: GridSummaryType.sum),
                              const GridSummaryColumn(
                                  name: 'kredit',
                                  columnName: 'kredit',
                                  summaryType: GridSummaryType.sum),
                            ],
                            position: GridTableSummaryRowPosition.bottom)
                      ],
                      source: BalanceDataSource(
                          balance: context.read<BalanceProvider>().balance),
                      columns: [
                        GridColumn(
                            columnName: 'id',
                            width: 50,
                            autoFitPadding: const EdgeInsets.all(0),
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '№',
                                ))),
                        GridColumn(
                            columnName: 'registrator',
                            autoFitPadding: const EdgeInsets.all(0),
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Операция',
                                ))),
                        GridColumn(
                            columnName: 'date',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Дата',
                                ))),
                        GridColumn(
                            columnName: 'debit',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Дебет',
                                ))),
                        GridColumn(
                            columnName: 'kredit',
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            label: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Кредит',
                                ))),
                      ]),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Конечный остаток",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child:
                        Text(balanceProvider.final_balance['debet'].toString()),
                  ),
                  Text(balanceProvider.final_balance['credit'].toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceDataSource extends DataGridSource {
  BalanceDataSource({required List<Balance> balance}) {
    _employees = balance
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'registrator', value: e.registrator),
              DataGridCell<String>(
                  columnName: 'date', value: e.registratorDate),
              DataGridCell<double>(columnName: 'debit', value: e.debet),
              DataGridCell<double>(columnName: 'kredit', value: e.kredit),
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
        width: 100,
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
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
