import 'package:drc/providers/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AssetsChart extends StatefulWidget {
  @override
  _AssetsChartState createState() => _AssetsChartState();
}

class _AssetsChartState extends State<AssetsChart> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.88,
      height: /* (data.pieasset.isEmpty)
          ? MediaQuery.of(context).size.height * 0.2
          : */
          (data.assetamount.isEmpty)
              ? MediaQuery.of(context).size.height * 0.2
              : (data.pieasset[0].y == 0 &&
                      data.pieasset[1].y == 0 &&
                      data.pieasset[2].y == 0 &&
                      data.pieasset[3].y == 0)
                  ? MediaQuery.of(context).size.height * 0.2
                  : MediaQuery.of(context).size.height * 0.6,
      // color: Colors.grey,
      decoration: BoxDecoration(
        color: Color.fromRGBO(249, 247, 247, 1),
        // color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              (Text('Assets Owned',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(9, 51, 116, 1)))),
              SizedBox(height: 20),
            ],
          ),
          (data.assetamount.isEmpty)
              ? SizedBox(height: 20)
              : (data.pieasset[0].y == 0 &&
                      data.pieasset[1].y == 0 &&
                      data.pieasset[2].y == 0 &&
                      data.pieasset[3].y == 0)
                  ? SizedBox(height: 20)
                  : Container(
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          DoughnutSeries<AssetData, String>(
                              dataSource: data.pieasset,
                              pointColorMapper: (AssetData data, _) =>
                                  data.color,
                              xValueMapper: (AssetData data, _) => data.x,
                              yValueMapper: (AssetData data, _) => data.y,
                              // Corner style of doughnut segment
                              cornerStyle: CornerStyle.bothFlat,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  // Positioning the data label
                                  labelPosition:
                                      ChartDataLabelPosition.outside))
                        ],
                      ),
                    ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 15,
                          width: 20,
                          color: Color.fromRGBO(255, 197, 51, 1)),
                      SizedBox(width: 10),
                      Container(
                        child: Text('Gold',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(9, 51, 116, 1))),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 15,
                          width: 20,
                          color: Color.fromRGBO(2, 211, 204, 1)),
                      SizedBox(width: 10),
                      Container(
                        child: Text('Platinum',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(9, 51, 116, 1))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 15,
                          width: 20,
                          color: Color.fromRGBO(188, 149, 223, 1)),
                      SizedBox(width: 10),
                      Container(
                        child: Text('Silver',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(9, 51, 116, 1))),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 15,
                          width: 20,
                          color: Color.fromRGBO(242, 114, 111, 1)),
                      SizedBox(width: 10),
                      Container(
                        child: Text('Palladium',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(9, 51, 116, 1))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
