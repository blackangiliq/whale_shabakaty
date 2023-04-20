import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habkty_whale/Tv_Screens/the_movie_item_deteils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Tv_main_Screen extends StatefulWidget {
  @override
  _Tv_main_ScreenState createState() => _Tv_main_ScreenState();
}

class _Tv_main_ScreenState extends State<Tv_main_Screen> {
  List<dynamic> exploresData = [];

  bool loading = false;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://shasha.koolshy.co:8090/api/home/'));
    final jsonData = json.decode(response.body);
    setState(() {
      exploresData = jsonData['explores'];
      loading = true;
    });
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: loading
          ? ListView.builder(
        itemCount: exploresData.length,
        itemBuilder: (BuildContext context, int index) {
          final explore = exploresData[index];
          final title = explore['title'];
          final items = explore['items'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Text(
                "$title  ",
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 310,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    final itemTitle = item['title'];
                    final itemPoster = item['poster'];
                    // Add this line
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsPage(
                              mediaId: item['media_id'].toString(),
                              mediaType: item['media_type'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right : 5, left: 5.0),
                        child: SizedBox(
                          width: 190,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              //decorated box with border radius and box shadow
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0,
                                          3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Image.network(

                                      itemPoster,
                                      fit: BoxFit.fill,
                                      height: 260,
                                      width: 200,
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.only(top: 13.0),
                                child: Center(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: itemTitle,
                                      style: const TextStyle(
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      )
          : const Center(child: Text("loading...")),
    );
  }
}
