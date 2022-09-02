import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/feedback_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<FeedbackModel>> feedbackModels;
  String searchString = "Search";

  @override
  void initState() {
    super.initState();
    feedbackModels = getFeedbackFromSheet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bird Spotter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(centerTitle: true, backgroundColor: Colors.black54, title: const Text('Bird Spotter', textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            )
          )
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text('Search a bird by name and find out that country has the most birds spotted.', textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                )
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                    labelText: 'Search by bird Name', suffixIcon: Icon(Icons.search)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                builder: (context, AsyncSnapshot<List<FeedbackModel>> snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(1),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data![index].commonName
                              .toLowerCase()
                              .contains(searchString)
                              ? ListTile(
                            minLeadingWidth: 50,
                            leading: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.network(
                                  '${snapshot.data?[index].birdURL}',
                                width: 80,
                                height: 50,),
                            ),
                            title: Text('${snapshot.data?[index].commonName}',
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              textAlign: TextAlign.center,),
                            subtitle: Text(
                                'Total: ${snapshot.data?[index].countryTotal}',
                              style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueAccent,
                                    letterSpacing: 1,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.network(
                                  '${snapshot.data?[index].countryImg}',
                                  width: 80,
                                  height: 50,
                              ),
                            ),
                          )
                              : Container();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return snapshot.data![index].commonName
                              .toLowerCase()
                              .contains(searchString)
                              ? const Divider()
                              : Container();
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something is wrong please check your connection'));
                  } else {
                    return const Center(child: Text('Searching...'));
                  }
                  return const CircularProgressIndicator();
                },
                future: feedbackModels,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<FeedbackModel>> getFeedbackFromSheet() async {

  var raw = await http.get(
      "https://script.google.com/macros/s/AKfycbyq2glkqwpJqr4R3lgkTk6jjsS-mdGkUjhu1mVfXcwDpAtrGs_hsNfCM5Yp78jEKg_R/exec");

  if (raw.statusCode == 200) {
    var jsonFeedback = convert.jsonDecode(raw.body) as List;
    return jsonFeedback.map((feedbackModel) => FeedbackModel.fromJson(feedbackModel)).toList();
  } else {
    throw Exception('Failed to load Data');
  }

}