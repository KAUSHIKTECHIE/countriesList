import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'favourite_countries.dart';

class CountriesList extends StatefulWidget {
  static const String routeName = "/CountriesList";

  const CountriesList({Key key}) : super(key: key);

  @override
  _CountriesListState createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  Future<Map<String, dynamic>> serverData;

  var favList = new Map<String, dynamic>();
  var countryCode = "";
  var countryName = "";
  var regionName = "";
  List<bool> _isFavorited;
  Map<String, dynamic> listData;

  @override
  void initState() {
    super.initState();
    serverData = getServerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tatsam App"),
          backgroundColor: Colors.indigo.withOpacity(0.4),
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouriteCountriesList(),
                    // Pass the arguments as part of the RouteSettings. The
                    // DetailScreen reads the arguments from these settings.
                    settings: RouteSettings(
                      arguments: favList,
                    ),
                  ),
                );
              });
            },
            icon: Icon(Icons.favorite_border_outlined),
          ),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.indigo.withOpacity(0.4),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(height: 30, child: Text("Country List")),
                FutureBuilder<Map<String, dynamic>>(
                  future: serverData, //sets serverData as the expected Future
                  builder: (context, snapshot) {
                    // CounterUtil.incrementStreamCounterForLabel("future builder");
                    if (snapshot.hasData) {
                      //checks for non-null return value from serverData
                      return Expanded(
                          child: getListView(
                        snapshot.data,
                        "server",
                      )); // snapshot.data is return value of serverData
                    } else if (snapshot.hasError) {
                      //checks if the response threw error
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget getListView(listData, mapKey) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          countryCode = listData.keys.elementAt(index);
          countryName = listData[countryCode]["country"];
          regionName = listData[countryCode]["region"];
          return InkWell(
            onTap: () {
              setState(() {
                favList = {};
                _isFavorited[index] = !_isFavorited[index];
                for (var i = 0; i <= listData.length - 1; i++) {
                  _isFavorited[i]
                      ? favList[listData.keys.elementAt(i)] =
                          listData[listData.keys.elementAt(i)]
                      : null;
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Code - '),
                          Text('$countryCode'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Name -'),
                          Expanded(child: Text('$countryName')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Region -'),
                          Text('$regionName'),
                        ],
                      ),
                      Divider(),
                    ],
                  )),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        favList = {};
                        _isFavorited[index] = !_isFavorited[index];

                        for (var i = 0; i <= listData.length - 1; i++) {
                          _isFavorited[i]
                              ? favList[listData.keys.elementAt(i)] =
                                  listData[listData.keys.elementAt(i)]
                              : null;
                        }
                      });
                    },
                    icon: _isFavorited[index]
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getServerData() async {
    String url = 'https://api.first.org/data/v1/countries';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      _isFavorited =
          List.filled(json.decode(response.body)["data"].length, false);

      return json.decode(response.body)["data"];
    } else {
      throw Exception('Failed to load post ${response.statusCode}');
    }
  }
}
