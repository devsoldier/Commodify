import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:intl/intl.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  String _selectedfilter = 'all';
  List filters = [
    'all',
    'topup',
    'withdraw',
  ];

  String _selectedsort = 'sort old';
  List sortfilters = [
    'sort old',
    'sort new',
  ];

  void getPayHistory(_selectedfilter, _selectedsort) {
    Provider.of<Auth>(context, listen: false)
        .getpaymenthistory(_selectedfilter, _selectedsort);
  }

  @override
  void initState() {
    getPayHistory(_selectedfilter, _selectedsort);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentdata = Provider.of<Auth>(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 90,
              height: 50,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedfilter,
                  onChanged: (newval) {
                    setState(() {
                      _selectedfilter = newval as String;
                      getPayHistory(_selectedfilter, _selectedsort);
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
                      getPayHistory(_selectedfilter, _selectedsort);
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
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.38,
          child: ListView.builder(
            itemCount: paymentdata.phistoryfiltered.length,
            itemBuilder: (_, i) => Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: (paymentdata.phistoryfiltered[i].payment_type ==
                              "Withdraw")
                          ? Container(
                              // color: Colors.black,
                              width: 100,
                              height: 50,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/navbar/v red.png',
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '${paymentdata.phistoryfiltered[i].payment_type}',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          : (paymentdata.phistoryfiltered[i].payment_type ==
                                  "Topup")
                              ? Container(
                                  width: 100,
                                  height: 50,
                                  // color: Colors.black,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/navbar/v green.png',
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        '${paymentdata.phistoryfiltered[i].payment_type}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                      title: Center(
                        child: Container(
                          width: 50,
                          height: 15,
                          child: Text(
                              '${paymentdata.phistoryfiltered[i].payment_amount}'),
                        ),
                      ),
                      trailing: (paymentdata
                                  .phistoryfiltered[i].payment_status ==
                              "Completed")
                          ? Container(
                              // color: Colors.black,
                              width: 90,
                              height: 20,
                              child: Column(
                                children: [
                                  Text(
                                    '${paymentdata.phistoryfiltered[i].payment_status}',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          : (paymentdata.phistoryfiltered[i].payment_status ==
                                  "Cancelled")
                              ? Container(
                                  width: 50,
                                  height: 15,
                                  child: Column(
                                    children: [
                                      Text(
                                        '${paymentdata.phistoryfiltered[i].payment_status}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                    ),
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
