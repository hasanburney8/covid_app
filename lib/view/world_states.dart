import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/view/countires_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Model/WorldStatesModel.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices(); //introducing the states services here
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),                 //hitted api is called here
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {    //<WorldStatesModel> makes the inside of WorldStatesModel possible
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(  //this is the loading animation that happens when data isnt found
                        color: Colors.white,       //this is the loading animation that happens when data isnt found
                        size: 50.0,                //this is the loading animation that happens when data isnt found
                        controller: _controller,   //same controller created at line 18
                      ),
                    );
                  } else {
                    return Column(children: [
                      PieChart(
                        dataMap: {
                          "Total": double.parse(snapshot.data!.cases!.toString()),
                          "Recovered": double.parse(snapshot.data!.recovered.toString()),
                          "Deaths": double.parse(snapshot.data!.deaths.toString()),
                        },
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,    //gives big values in the form of percentage in piechart
                        ),
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left,
                        ),
                        animationDuration: const Duration(milliseconds: 1200),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.06),
                        child: Card(
                          child: Column(
                            children: [
                              ReusableRow(
                                  title: 'Total',
                                  value: snapshot.data!.cases.toString()),
                              ReusableRow(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths.toString()),
                              ReusableRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered.toString()),
                              ReusableRow(
                                  title: 'Active',
                                  value: snapshot.data!.active.toString()),
                              ReusableRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical.toString()),
                              ReusableRow(
                                  title: 'Today recovered',
                                  value:
                                      snapshot.data!.todayRecovered.toString())
                            ],
                          ),
                        ),
                      ),


                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesListScreen()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text('Track Countries'),
                          ),
                        ),
                      )
                    ]);
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider()
        ],
      ),
    );
  }
}
