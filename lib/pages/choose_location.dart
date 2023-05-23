import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:world_time/blocs/search_filter/search_filter_bloc.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';
import 'package:world_time/services/world_time.dart';

class ChooseLocation extends StatefulWidget {
  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  // List<dynamic> items = [];
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    context.read<WorldTimeListBloc>().add(FetchWorldTimeList());
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

  // void filterSearchResults(String query) {
  //   setState(() {
  //     items = context
  //         .read<WorldTimeListBloc>()
  //         .state
  //         .timeData
  //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var searchfilter = context.watch<SearchFilterBloc>();
    List<dynamic> timezones = context.watch<WorldTimeListBloc>().state.timeData;
    List<dynamic> filteredTimeZones =
        context.watch<SearchFilterBloc>().state.filteredTodo;

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Location'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          elevation: 0,
        ),
        body: timezones.isEmpty
            ? Center(
                child: SpinKitFadingFour(
                  color: Colors.black,
                  size: 50.0,
                ),
              )
            : Column(
                children: [
                  DropdownButton(
                    alignment: Alignment.center,
                    value: (searchfilter.state.filter == Filter.all)
                        ? 'all'
                        : (searchfilter.state.filter == Filter.africa)
                            ? 'africa'
                            : (searchfilter.state.filter == Filter.america)
                                ? 'america'
                                : (searchfilter.state.filter ==
                                        Filter.antartica)
                                    ? 'antartica'
                                    : (searchfilter.state.filter == Filter.asia)
                                        ? 'asia'
                                        : (searchfilter.state.filter ==
                                                Filter.australia)
                                            ? 'australia'
                                            : 'europe',
                    // Step 4.
                    items: [
                      'all',
                      'asia',
                      'africa',
                      'america',
                      'antartica',
                      'australia',
                      'europe'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }).toList(),

                    // Step 5.
                    onChanged: (value) {
                      Filter filter;
                      if (value == 'all') {
                        filter = Filter.all;
                      } else if (value == 'africa') {
                        filter = Filter.africa;
                      } else if (value == 'america') {
                        filter = Filter.america;
                      } else if (value == 'antartica') {
                        filter = Filter.antartica;
                      } else if (value == 'asia') {
                        filter = Filter.asia;
                      } else if (value == 'australia') {
                        filter = Filter.australia;
                      } else {
                        filter = Filter.europe;
                      }

                      searchfilter.state.filter = filter;
                      context.read<SearchFilterBloc>().setFilterAndSearch(
                          searchfilter.state.filter, editingController.text);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: editingController,
                      onChanged: (value) {
                        if (editingController.text.isNotEmpty) {
                          context.read<SearchFilterBloc>().setFilterAndSearch(
                              searchfilter.state.filter,
                              editingController.text);
                        }
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
                        itemCount: filteredTimeZones.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 4),
                            child: Card(
                              child: ListTile(
                                onTap: () {
                                  updateTime(filteredTimeZones[index]);
                                },
                                title: Text(filteredTimeZones[index]),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ));
  }
}
