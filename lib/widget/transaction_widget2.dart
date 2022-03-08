import 'package:drc/providers/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';

class TransactionWidget2 extends StatefulWidget {
  @override
  _TransactionWidget2State createState() => _TransactionWidget2State();
}

class _TransactionWidget2State extends State<TransactionWidget2> {
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

    void setdata() {
      if (_selectedfilter == 'all' && _selectedsort == 'sort old') {}
    }

    Widget listviewcontent = ListView.builder(
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
              ListTile(
                leading: (historydata.history[i].tx_asset == "gold")
                    ? Image.asset('assets/navbar/gold 1.png')
                    : Text('WIP'),
                title: (historydata.history[i].tx_type == 'buy')
                    ? Center(
                        child: Text('-${historydata.history[i].tx_amount}',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )
                    : Center(
                        child: Text('+${historydata.history[i].tx_amount}',
                            style: TextStyle(color: Colors.green)),
                      ),
                subtitle: Center(child: Text('USD')),
                trailing: (historydata.history[i].tx_type == 'buy')
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(168, 255, 187, 1)),
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
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(240, 186, 182, 1)),
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
              ),
            ],
          ),
        ),
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
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
              width: 50,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedsort,
                  onChanged: (newval) {
                    setState(() {
                      _selectedsort = newval as String;
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
            child: listviewcontent),
      ],
    );
  }
}
