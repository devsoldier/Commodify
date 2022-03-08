import 'package:drc/providers/models.dart';
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
    'sort old',
    'sort new',
  ];

  String _selectedsort = 'sort old';
  List sortfilters = [
    'sort old',
    'sort new',
  ];

  @override
  Widget build(BuildContext context) {
    final historydata = Provider.of<Auth>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: _selectedfilter,
              onChanged: (newval) {
                setState(() {
                  _selectedfilter = newval as String;
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
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: (_selectedfilter == 'all')
                ? historydata.history.length
                : (_selectedfilter == 'buy')
                    ? historydata.historybuy.length
                    : (_selectedfilter == 'sell')
                        ? historydata.historysell.length
                        : (_selectedfilter == 'sort old')
                            ? historydata.historyoldestdate.length
                            : historydata.historylatestdate.length,
            itemBuilder: (_, i) => Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    //ALL
                    (_selectedfilter == 'all')
                        ? ListTile(
                            leading: (historydata.history[i].tx_asset == "gold")
                                ? Image.asset('assets/navbar/gold 1.png')
                                : Text('WIP'),
                            title: (historydata.history[i].tx_type == 'buy')
                                ? Center(
                                    child: Text(
                                        '-${historydata.history[i].tx_amount}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : Center(
                                    child: Text(
                                        '+${historydata.history[i].tx_amount}',
                                        style: TextStyle(color: Colors.green)),
                                  ),
                            subtitle: Center(child: Text('USD')),
                            trailing: (historydata.history[i].tx_type == 'buy')
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
                                                168, 255, 187, 1)),
                                        child: Text(
                                          'Buy',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat('dd MMM hh:mm ').format(historydata.history[i].epoch)}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  )
                                : Column(
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
                                        '${DateFormat('dd/MMM hh:mm ').format(historydata.history[i].epoch)}',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                          )
                        : (_selectedfilter == 'buy')
                            ?
                            //BUY
                            ListTile(
                                leading: (historydata.historybuy[i].tx_asset ==
                                        "gold")
                                    ? Image.asset('assets/navbar/gold 1.png')
                                    : null,
                                title: /* (historydata.history[i].tx_type == 'buy')
                                    ?  */
                                    Center(
                                  child: Text(
                                      '-${historydata.historybuy[i].tx_amount}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ) /*  : null*/,
                                subtitle:
                                    /* (historydata.history[i].tx_type == 'buy')
                                        ?  */
                                    Center(child: Text('USD')) /* : null */,
                                trailing: /* (historydata.history[i].tx_type ==
                                        'buy')
                                    ?  */
                                    Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                      '${DateFormat('dd MMM hh:mm ').format(historydata.historybuy[i].epoch)}',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                )
                                /*  : null, */
                                )
                            :
                            //SELL
                            (_selectedfilter == "sell")
                                ? ListTile(
                                    leading: (historydata
                                                .historysell[i].tx_asset ==
                                            "gold" /* &&
                                        historydata.history[i].tx_type ==
                                            'sell' */
                                        )
                                        ? /* ?  */ Image.asset(
                                            'assets/navbar/gold 1.png')
                                        : null,
                                    title: /* (historydata.history[i].tx_type ==
                                        'sell')
                                    ?  */
                                        Center(
                                      child: Text(
                                          '+${historydata.historysell[i].tx_amount}',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ) /* : null */,
                                    subtitle:
                                        /* (historydata.history[i].tx_type == 'sell')
                                        ?  */
                                        Center(child: Text('USD')) /* : null */,
                                    trailing: /*  (historydata.history[i].tx_type ==
                                        'sell')
                                    ?  */
                                        Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Color.fromRGBO(
                                                  240, 186, 182, 1)),
                                          child: Text(
                                            'sell',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          '${DateFormat('dd MMM hh:mm ').format(historydata.historysell[i].epoch)}',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    )
                                    /*  : null, */
                                    )
                                :
                                //SORT OLD
                                (_selectedfilter == "sort old")
                                    ? ListTile(
                                        leading: (historydata
                                                    .historyoldestdate[i]
                                                    .tx_asset ==
                                                "gold")
                                            ? Image.asset(
                                                'assets/navbar/gold 1.png')
                                            : Text('WIP'),
                                        title: (historydata.historyoldestdate[i]
                                                    .tx_type ==
                                                'buy')
                                            ? Center(
                                                child: Text(
                                                    '-${historydata.historyoldestdate[i].tx_amount}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : Center(
                                                child: Text(
                                                    '+${historydata.historyoldestdate[i].tx_amount}',
                                                    style: TextStyle(
                                                        color: Colors.green)),
                                              ),
                                        subtitle: Center(child: Text('USD')),
                                        trailing: (historydata
                                                    .historyoldestdate[i]
                                                    .tx_type ==
                                                'buy')
                                            ? Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Color.fromRGBO(
                                                            168, 255, 187, 1)),
                                                    child: Text(
                                                      'Buy',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd MMM hh:mm ').format(historydata.historyoldestdate[i].epoch)}',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Color.fromRGBO(
                                                            240, 186, 182, 1)),
                                                    child: Text(
                                                      'Sell',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd/MMM hh:mm ').format(historydata.historyoldestdate[i].epoch)}',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                      )
                                    :
                                    //SORT NEW
                                    ListTile(
                                        leading: (historydata
                                                    .historylatestdate[i]
                                                    .tx_asset ==
                                                "gold")
                                            ? Image.asset(
                                                'assets/navbar/gold 1.png')
                                            : Text('WIP'),
                                        title: (historydata.historylatestdate[i]
                                                    .tx_type ==
                                                'buy')
                                            ? Center(
                                                child: Text(
                                                    '-${historydata.historylatestdate[i].tx_amount}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : Center(
                                                child: Text(
                                                    '+${historydata.historylatestdate[i].tx_amount}',
                                                    style: TextStyle(
                                                        color: Colors.green)),
                                              ),
                                        subtitle: Center(child: Text('USD')),
                                        trailing: (historydata
                                                    .historylatestdate[i]
                                                    .tx_type ==
                                                'buy')
                                            ? Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Color.fromRGBO(
                                                            168, 255, 187, 1)),
                                                    child: Text(
                                                      'Buy',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd MMM hh:mm ').format(historydata.historylatestdate[i].epoch)}',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Color.fromRGBO(
                                                            240, 186, 182, 1)),
                                                    child: Text(
                                                      'Sell',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd/MMM hh:mm ').format(historydata.historylatestdate[i].epoch)}',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
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
