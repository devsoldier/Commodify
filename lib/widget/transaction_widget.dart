// import 'package:drc/providers/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatefulWidget {
  @override
  _TransactionWidgetState createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  String _selectedfilter = 'all';
  List filters = [
    'all',
    'buy',
    'sell',
  ];

  String _selectedsort = 'sort old';
  List sortfilters = [
    'sort old',
    'sort new',
  ];

  void getTransHistory(_selectedfilter, _selectedsort) {
    Provider.of<Auth>(context, listen: false)
        .gethistory(_selectedfilter, _selectedsort);
  }

  @override
  void initState() {
    getTransHistory(_selectedfilter, _selectedsort);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historydata = Provider.of<Auth>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedfilter,
                  onChanged: (newval) {
                    setState(() {
                      _selectedfilter = newval as String;
                      getTransHistory(_selectedfilter, _selectedsort);
                    });
                  },
                  elevation: 16,
                  items: filters.map((newval) {
                    return DropdownMenuItem(
                      value: newval,
                      child: Text(newval),
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedsort,
                  onChanged: (newval) {
                    setState(() {
                      _selectedsort = newval as String;
                      getTransHistory(_selectedfilter, _selectedsort);
                    });
                  },
                  elevation: 16,
                  items: sortfilters.map((newval) {
                    return DropdownMenuItem(
                      value: newval,
                      child: Text(newval),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: historydata.historyfiltered.length,
            itemBuilder: (_, i) => Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    //ALL and OLD

                    Container(
                      color: Color.fromRGBO(249, 247, 247, 1),
                      // color: (i % 2 == 0)
                      //     ? Color.fromRGBO(18, 39, 70, 1)
                      //     : Color.fromRGBO(5, 157, 230, 1),
                      child: ListTile(
                        leading:
                            (historydata.historyfiltered[i].tx_asset == "gold")
                                ? Image.asset('assets/navbar/gold 1.png')
                                : Image.asset(
                                    'assets/navbar/silver.png',
                                    width: 50,
                                    height: 50,
                                  ),
                        title: (historydata.historyfiltered[i].tx_type == 'buy')
                            ? Center(
                                child: Text(
                                    '-${historydata.historyfiltered[i].tx_amount}',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              )
                            : (historydata.historyfiltered[i].tx_type == 'sell')
                                ? Center(
                                    child: Text(
                                        '+${historydata.historyfiltered[i].tx_amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  )
                                : null,
                        subtitle: Center(child: Text('USD')),
                        trailing: (historydata.historyfiltered[i].tx_type ==
                                'buy')
                            ? Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromRGBO(168, 255, 187, 1)),
                                    child: Text(
                                      'Buy',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat('dd MMM hh:mm ').format(historydata.historyfiltered[i].epoch)}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              )
                            : (historydata.historyfiltered[i].tx_type == 'sell')
                                ? Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color.fromRGBO(
                                                240, 186, 182, 1)),
                                        child: Text(
                                          'Sell',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat('dd/MMM hh:mm ').format(historydata.historyfiltered[i].epoch)}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  )
                                : null,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
