import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Tv_Screens/the_movie_item_deteils.dart';
import 'mobile_move_item_detels.dart';

class CinemaMainScreen extends StatefulWidget {
  @override
  _CinemaMainScreenState createState() => _CinemaMainScreenState();
}

class _CinemaMainScreenState extends State<CinemaMainScreen> {
  List<dynamic> exploresData = [];
  Map intro = {};
  bool loading = false;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Movies'),
    Text('TV Shows'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://shasha.koolshy.co:8090/api/home/'));
    final jsonData = json.decode(response.body);
    setState(() {
      exploresData = jsonData['explores'];
      intro = jsonData['intro'];

      loading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add items to the drawer here
      ),
      body: loading
          ?
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: exploresData.length,
        itemBuilder: (BuildContext context, int index) {
          final explore = exploresData[index];
          final title = explore['title'];
          final items = explore['items'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Change the crossAxisAlignment to start
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 1.0),
                child: Text(
                  "$title   ",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    final itemTitle = item['title'];
                    final itemPoster = item['poster'];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MobileMoveItemDitels(
                              mediaId: item['media_id'].toString(),
                              mediaType: item['media_type'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5.0),
                        child: SizedBox(
                          width: 110,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                        0,
                                        3,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      itemPoster,
                                      fit: BoxFit.fill,
                                      height: 160, // adjust height
                                      width: 160, // adjust width
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 13.0),
                                child: Center(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2, // limit to 2 lines
                                    text: TextSpan(
                                      text: itemTitle,
                                      style: const TextStyle(
                                        fontSize: 16, // adjust font size
                                      ),
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
          : const Center(
          child: Text('loading...')
      ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'TV Shows',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white, // Add this line
          onTap: _onItemTapped,
        ),

    );
  }

}
