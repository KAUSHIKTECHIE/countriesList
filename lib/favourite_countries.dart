import 'package:flutter/material.dart';

class FavouriteCountriesList extends StatelessWidget {
  static const String routeName = "/FavouriteCountriesList";

  const FavouriteCountriesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favList =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tatsam App'),
          backgroundColor: Colors.indigo.withOpacity(0.4),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.indigo.withOpacity(0.4),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: favList.isEmpty
                ? Center(
                    child: Text("No Favourite Selected"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(height: 30, child: Text("Favourite List")),
                      Expanded(
                          child: getListView(
                        favList,
                        "server",
                      )), // snapshot.data is return value of serverData
                    ],
                  ),
          ),
        ));
  }

  Widget getListView(Map<String, dynamic> listData, mapKey) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Code - '),
                      Text('${listData.keys.elementAt(index)}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Name -'),
                      Expanded(
                          child: Text(
                              '${listData[listData.keys.elementAt(index)]["country"]}'))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Region -'),
                      Text(
                          '${listData[listData.keys.elementAt(index)]["region"]}'),
                    ],
                  ),
                  Divider(),
                ],
              ));
        },
      ),
    );
  }
}
