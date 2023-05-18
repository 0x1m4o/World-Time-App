import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  List<String> timeZones = [];
  var items = <String>[];
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    getWorld();
    super.initState();
  }

  @override
  void dispose() {
    editingController.clear();
    super.dispose();
  }

  void updateTime(url) async {
    WorldTime instance = WorldTime(
      url: url,
    );
    await instance.getTime();
    // Navigate to the homescreen
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'time': instance.time,
      'url': instance.url,
      'isDayTime': instance.isDayTime
    });
  }

  Future<void> getWorld() async {
    final apiUrl =
        Uri.parse('https://timeapi.io/api/TimeZone/AvailableTimeZones');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        timeZones = data.cast<String>();
      });
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      items = timeZones
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Location'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          elevation: 0,
        ),
        body: timeZones.isEmpty
            ? Center(
                child: SpinKitFadingFour(
                  color: Colors.black,
                  size: 50.0,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: editingController,
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: editingController.text.isNotEmpty
                            ? items.length
                            : timeZones.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 4),
                            child: Card(
                              child: ListTile(
                                onTap: () {
                                  updateTime(editingController.text.isNotEmpty
                                      ? items[index]
                                      : timeZones[index]);
                                },
                                title: Text(editingController.text.isNotEmpty
                                    ? items[index]
                                    : timeZones[index]),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ));
  }
}
