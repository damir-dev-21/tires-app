import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/services/background_fetch.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/search_item_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double minHeightOfSheet = 0;
  bool isDrag = false;
  var categoryValue = '';
  var producerValue = '';
  var typesizeValue = '';

  @override
  void initState() {
    super.initState();
    minHeightOfSheet = 450;
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
      ),
      body: SlidingUpPanel(
          backdropEnabled: true,
          borderRadius: BorderRadius.circular(20),
          minHeight: minHeightOfSheet,
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 18.0, color: Color.fromRGBO(0, 0, 0, 0.35))
          ],
          backdropOpacity: 0,
          backdropColor: Colors.black,
          isDraggable: false,
          maxHeight: 800,
          backdropTapClosesPanel: false,
          panel: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: isDrag
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  minHeightOfSheet = 500;
                                  isDrag = false;
                                });
                              },
                              icon: const Icon(Icons.keyboard_double_arrow_up))
                          : Text(
                              langs[authProvider.langIndex]['filter'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    alignment: AlignmentDirectional.centerStart,
                                    hint: Text(
                                      langs[authProvider.langIndex]['category'],
                                    ),
                                    value: categoryValue == ''
                                        ? null
                                        : categoryValue,
                                    items: context
                                        .read<ProductProvider>()
                                        .categories
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        categoryValue = e!;
                                      });
                                    }),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      categoryValue = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      langs[authProvider.langIndex]['producer'],
                                    ),
                                    value: producerValue == ''
                                        ? null
                                        : producerValue,
                                    items: context
                                        .read<ProductProvider>()
                                        .producers
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        producerValue = e!;
                                      });
                                    }),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      producerValue = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      langs[authProvider.langIndex]['type'],
                                    ),
                                    value: typesizeValue == ''
                                        ? null
                                        : typesizeValue,
                                    items: context
                                        .read<ProductProvider>()
                                        .typesizes
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (e) {
                                      setState(() {
                                        typesizeValue = e!;
                                      });
                                    }),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      typesizeValue = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: minHeightOfSheet / 1.1,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 45,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => appColor)),
                            onPressed: () {
                              setState(() {
                                minHeightOfSheet = 60;
                                isDrag = true;
                              });
                              context.read<ProductProvider>().setFilter(
                                  categoryValue, producerValue, typesizeValue);
                            },
                            child: Text(
                              langs[authProvider.langIndex]['filter_action'],
                              style: TextStyle(fontSize: 16),
                            )),
                      ))))
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount:
                            context.read<ProductProvider>().filteredList.length,
                        itemBuilder: (ctx, i) {
                          final product =
                              context.read<ProductProvider>().filteredList[i];
                          return SearchItemWidget(
                            product: product,
                            type: 'order',
                          );
                        }))
              ],
            ),
          )),
    );
  }
}
