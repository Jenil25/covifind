import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CovidIndia extends StatefulWidget {
  @override
  _CovidIndiaState createState() => _CovidIndiaState();
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
                          Text("TOTAL"),
                          // Divider(
                          //   indent: 10.0,
                          //   endIndent: 10.0,
                          // ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "${left.toString().replaceAllMapped(reg, mathFunc)}",
                            style: TextStyle(color: c),
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
                          Text("TODAY"),
                          SizedBox(height: 5.0),
                          Text(
                            "${right.toString().replaceAllMapped(reg, mathFunc)}",
                            style: TextStyle(color: c),
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
                      "STATE CODE",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                                "${data["statecode"]}",
                                style: TextStyle(color: Colors.white),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                            "${data["active"].toString().replaceAllMapped(reg, mathFunc)}",
                            style: TextStyle(color: Colors.white),
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
      MiniCard("CONFIRMED CASES", data["confirmed"], data["deltaconfirmed"],
          Colors.orange),
      MiniCard(
          "RECOVERED", data["recovered"], data["deltarecovered"], Colors.green),
      MiniCard("DEATHS", data["deaths"], data["deltadeaths"], Colors.red),
    ],
  );
}

class _CovidIndiaState extends State<CovidIndia> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    covidstates();
  }

  void covidstates() async {
    var data;
    final response =
        await http.Client().get("https://api.covid19india.org/data.json");
    data = json.decode(response.body);

    var statedata = [];

    for (var i in data["statewise"]) {
      if (i["state"] != "State Unassigned") statedata.add(i);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("India"),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: (20)),
              child: ListView.builder(
                itemCount: statedata.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text("${statedata[index]["state"]}"),
                      StateDataCard(statedata[index]),
                      Divider(),
                    ],
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
        title: Text("CoviFind"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
