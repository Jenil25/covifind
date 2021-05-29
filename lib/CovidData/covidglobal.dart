import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CovidGlobal extends StatefulWidget {
  @override
  _CovidGlobalState createState() => _CovidGlobalState();
}

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]}.';

Widget MiniCard(var title, var left, var right, Color c) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Center(
                child: Text(
              "$title",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          Text(
                            "TOTAL",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          // Divider(
                          //   indent: 10.0,
                          //   endIndent: 10.0,
                          // ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${left.toString().replaceAllMapped(reg, mathFunc)}",
                            style: TextStyle(color: c, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        children: [
                          Text(
                            "TODAY",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            "${right.toString().replaceAllMapped(reg, mathFunc)}",
                            style: TextStyle(color: c, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget StateDataCard(var data) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 135,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                        child: Text(
                      "COUNTRY CODE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "${data["CountryCode"]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 175,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                        child: Text(
                      "TOTAL ACTIVE CASES",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "${data["TotalConfirmed"].toString().replaceAllMapped(reg, mathFunc)}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      MiniCard("CONFIRMED CASES", data["TotalConfirmed"], data["NewConfirmed"],
          Colors.orange),
      MiniCard("RECOVERED", data["TotalRecovered"], data["NewRecovered"],
          Colors.green),
      MiniCard("DEATHS", data["TotalDeaths"], data["NewDeaths"], Colors.red),
    ],
  );
}

class _CovidGlobalState extends State<CovidGlobal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    covidcountries();
  }

  void covidcountries() async {
    var data;
    final response =
        await http.Client().get("https://api.covid19api.com/summary");
    data = json.decode(response.body);

    var countrydata = [];
    for (var i in data["Countries"]) {
      countrydata.add(i);
    }

    var globaldata = data["Global"];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Global Stats"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.all(10.0),
                            //   child: Container(
                            //     width: 135,
                            //     decoration: BoxDecoration(
                            //         color: Colors.blue,
                            //         borderRadius: BorderRadius.circular(10)),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 8.0),
                            //           child: Center(
                            //               child: Text(
                            //             "GLOBAL DATA",
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold),
                            //           )),
                            //         ),
                            //         // Padding(
                            //         //   padding: const EdgeInsets.all(8.0),
                            //         //   child: Center(
                            //         //     child: Row(
                            //         //       mainAxisAlignment: MainAxisAlignment.center,
                            //         //       children: [
                            //         //         Container(
                            //         //           decoration: BoxDecoration(
                            //         //               color: Colors.blue,
                            //         //               borderRadius: BorderRadius.circular(10)),
                            //         //           child: Center(
                            //         //             child: Text(
                            //         //               "${data["CountryCode"]}",
                            //         //               style: TextStyle(color: Colors.white),
                            //         //             ),
                            //         //           ),
                            //         //         ),
                            //         //       ],
                            //         //     ),
                            //         //   ),
                            //         // )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "TOTAL ACTIVE CASES",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                "${globaldata["TotalConfirmed"].toString().replaceAllMapped(reg, mathFunc)}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        MiniCard(
                            "CONFIRMED CASES",
                            globaldata["TotalConfirmed"],
                            globaldata["NewConfirmed"],
                            Colors.orange),
                        MiniCard("RECOVERED", globaldata["TotalRecovered"],
                            globaldata["NewRecovered"], Colors.green),
                        MiniCard("DEATHS", globaldata["TotalDeaths"],
                            globaldata["NewDeaths"], Colors.red),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: countrydata.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  "${countrydata[index]["Country"]}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade600),
                                ),
                              ),
                              Divider(
                                thickness: 1.5,
                              ),
                              StateDataCard(countrydata[index]),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   child: Row(
                      //     children: [
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Container(
                      //             width: MediaQuery.of(context).size.width * 0.5,
                      //             child: Text(
                      //               "Active: " + statedata[index]["active"],
                      //               style: TextStyle(
                      //                   color: Colors.black, fontSize: 16),
                      //               maxLines: 3,
                      //             ),
                      //           ),
                      //           SizedBox(height: 10),
                      //           Row(
                      //             children: [
                      //               Text.rich(
                      //                 TextSpan(
                      //                   text: "State: ${statedata[index]["state"]}",
                      //                   style: TextStyle(
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Global Stats"),
        centerTitle: true,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
