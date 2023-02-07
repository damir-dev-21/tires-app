// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/routes/router.dart';

class DeficitScreen extends StatefulWidget {
  const DeficitScreen({Key? key}) : super(key: key);

  @override
  State<DeficitScreen> createState() => _DeficitScreenState();
}

class _DeficitScreenState extends State<DeficitScreen> {
  late BalanceDataSource balanceDataSource;

  @override
  void initState() {
    super.initState();
    context.read<BalanceProvider>().getDeficitList();
  }

  @override
  Widget build(BuildContext context) {
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appColor,
        title: Text(langs[authProvider.langIndex]['deficit_list']),
        actions: [
          IconButton(
              onPressed: () async {
                await balanceProvider.getDeficitList();
              },
              icon: const Icon(Icons.sync))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(),
              child: Text(
                "Дефицитный лист " +
                    DateFormat("dd.MM.yyyy").format(DateTime.now()),
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height / 1.3,
              child: balanceProvider.isLoad
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: appColor,
                      ),
                    )
                  : SfDataGrid(
                      columnWidthMode: ColumnWidthMode.fill,
                      source: BalanceDataSource(
                          balance: context.read<BalanceProvider>().deficitList),
                      columns: [
                          GridColumn(
                              columnName: 'number',
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '№',
                                  ))),
                          GridColumn(
                              columnName: 'good',
                              columnWidthMode: ColumnWidthMode.fitByCellValue,
                              label: GestureDetector(
                                onTap: () {},
                                child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Товар',
                                    )),
                              )),
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
              DataGridCell<int>(columnName: 'number', value: e['НС']),
              DataGridCell<String>(columnName: 'good', value: e['Товар']),
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
      return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(),
          width: 50,
          padding: const EdgeInsets.all(16.0),
          child: Text(dataGridCell.value.toString()),
        ),
      );
    }).toList());
  }
}
