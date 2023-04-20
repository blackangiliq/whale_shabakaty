import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Tv_Screens/better_player.dart';
import 'mobile_film_vedio_player.dart';

class MobileMoveItemDitels extends StatefulWidget {
  final String mediaId;
  final String mediaType;

  MobileMoveItemDitels({required this.mediaId, required this.mediaType});

  @override
  _MobileMoveItemDitelsState createState() => _MobileMoveItemDitelsState();
}

class _MobileMoveItemDitelsState extends State<MobileMoveItemDitels> {
  late Future<Map<String, dynamic>> _futureMovieData;

  Future<Map<String, dynamic>> _fetchData() async {
    final response = await http.get(Uri.parse(
        'http://shasha.koolshy.co:8090/api/view?mediaType=${widget.mediaType}&mediaId=${widget.mediaId}&filter='));
    final jsonData = json.decode(response.body);
    final movieData = jsonData;
    return movieData;
  }

  @override
  void initState() {
    super.initState();
    _futureMovieData = _fetchData();
  }

  //show dialog with movie details
  void _showMovieDetails(BuildContext context, Map<String, dynamic> movieData) {
    print(movieData);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movieData['data']['name']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Text(
                  movieData['data']['storyline'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'النوع',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List<Widget>.from(
                    (movieData['data']['genres'] ?? []).map(
                          (genre) => Chip(
                        label: Text(genre),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الممثلين',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List<Widget>.from(
                    (movieData['actors'] ?? []).map(
                          (actor) => Chip(
                        label: Text(actor['name']),
                        avatar: CircleAvatar(
                          backgroundImage:
                          NetworkImage(actor['photo'] ?? ''),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('اغلاق'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureMovieData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            final movieData = snapshot.data!;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 390,
                        child: Image.network(
                          movieData['data']['poster'] ?? '',
                          scale: 1.0,
                          height: 350,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 1),
                        padding: const EdgeInsets.all(11.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          color: Colors.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //download button
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:  [
                                  const Icon(
                                    Icons.file_download_outlined,
                                  ),
                                  const SizedBox(width: 15),
                                  //info icon
                                  InkWell(
                                    onTap: () {
                                      _showMovieDetails( context, movieData);
                                    },
                                    child: const Icon(
                                      Icons.info_outline,
                                    ),
                                  ),
                                  //share icon
                                  const SizedBox(width: 15),
                                  const Icon(
                                    Icons.share_outlined,
                                  ),
                                  //favorite icon
                                  const SizedBox(width: 15),
                                  const Icon(
                                    Icons.favorite_border_outlined,
                                  ),
                                  //more icon

                                ],
                              ),
                            ),
                            Container(
                              //container with white side border
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              height: 260,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: movieData['similar'].length,
                                itemBuilder: (context, index) {
                                  final similarMovie = movieData['similar'][index];
                                  return Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    width: 130,
                                    height: 110,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          similarMovie['poster'] ?? '',
                                          height: 200,
                                          width: 130,
                                          fit: BoxFit.fill,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          similarMovie['name'] ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,

                    child: Container(
                      height: 390,

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: //the move title
                          Column(
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            movieData['data']['name'] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 50),
                          //play icon
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => film_video_player(
                                    mediaType: widget.mediaType
                                    ,

                                    mediaId:widget.mediaId,


                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                          //imdb rating and views number and year with icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //imdb rating
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movieData['data']['imdb']['rate'].toString().isEmpty ? '': movieData['data']['imdb']['rate'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              //views number
                              Row(
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movieData['data']['views'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),

                                ],
                              ),
                              const SizedBox(width: 20),
                              //year
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movieData['data']['year'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),


                                ],
                              ),

                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
