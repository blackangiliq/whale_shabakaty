import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habkty_whale/Tv_Screens/better_player.dart';
import 'package:habkty_whale/Tv_Screens/play_movie_page.dart';
import 'package:http/http.dart' as http;

import 'another_video_player.dart';

class MovieDetailsPage extends StatefulWidget {
  final String mediaId;
  final String mediaType;

  MovieDetailsPage({required this.mediaId, required this.mediaType});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool loading = false;
  Map<String, dynamic> movieDetails = {};

  Future<void> fetchMovieDetails() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(
        'http://shasha.koolshy.co:8090/api/view?mediaType=${widget
            .mediaType}&mediaId=${widget.mediaId}&filter='));

    final jsonData = json.decode(response.body);
    setState(() {
      movieDetails = jsonData;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  // void playMovie() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PlayPage(
  //         mediaType: widget.mediaType,
  //         mediaId: widget.mediaId,
  //       ),
  //     ),
  //   );
  // }
  void playBetter_plyaer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Better_plyaer(
              mediaType: widget.mediaType,
              mediaId: widget.mediaId,
            ),
      ),
    );
  }

//font style
  TextStyle _titleStyle() {
    return const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Montserrat',
      shadows: [
        Shadow(
          blurRadius: 5.0,
          color: Colors.black,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
  var _isFocused = false;
  @override
  Widget build(BuildContext context) {

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: Scaffold(
        body: loading
            ? const Center(child: Text("جاري التحميل"))
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 400, // adjust as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                    NetworkImage(movieDetails['data']['poster']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          Image.network(
                            movieDetails['data']['poster'],
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            //in the center of the parent
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Focus(
                              focusNode: FocusNode(),
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isFocused = hasFocus;
                                });
                              },
                              child: InkWell(
                                onTap: () {
                                  playBetter_plyaer();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                  child: Icon(
                                    Icons.play_circle,
                                    color: _isFocused ? Colors.blue : Colors.green,
                                    size: _isFocused ? 90 : 70,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      )

                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Custom app bar with Netflix logo and back button


                  // Movie title, rating, and views
                  const SizedBox(height: 5),
                  Text(
                    movieDetails['data']['name'],
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'NetflixSans',
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movieDetails['data']['imdb']['rate'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'NetflixSans',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.yellow, size: 24),
                      const SizedBox(width: 16),
                      Text(
                        movieDetails['data']['views'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'NetflixSans',
                        ),
                      ),
                      // Custom eye icon

                    ],
                  ),

                  const SizedBox(height: 32),

                  // Movie genre and storyline
                  Text(
                    'تصنيف  : ${movieDetails['data']['genres'].join(', ')} ',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'NetflixSans',
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 32),
                  const Text(
                    ': القصة  ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'NetflixSans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Custom rich text with overlay effect
                  Focus(
                    canRequestFocus: true,
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        print('focused');
                      } else {
                        print('not focused');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 52.0 , right: 52),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(

                          text: movieDetails['data']['storyline'],
                          style: const TextStyle(




                            fontSize: 29,
                            color: Colors.white,
                            fontFamily: 'NetflixSans',
                          ),

                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Actors section
                  const Text(
                    'الممثلين',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'NetflixSans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  movieDetails['actors'] == null
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetails['actors'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: SizedBox(
                            width: 180,
                            height: 110,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        movieDetails['actors'][index]['photo'],
                                        fit: BoxFit.cover,
                                        height: 170,
                                        width: 110,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 13),
                                  Center(
                                    child: Text(
                                      movieDetails['actors'][index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'NetflixSans',
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

                  const SizedBox(height: 32),

                  // Similar movies section
                  const Text(
                    'افلام مشابهة ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'NetflixSans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  movieDetails['similar'] == null
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetails['similar'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: SizedBox(
                            width: 220,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        movieDetails['similar'][index]['poster'],
                                        fit: BoxFit.cover,
                                        height: 216,
                                        width: 200,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 13),
                                  Center(
                                    child: Text(
                                      movieDetails['similar'][index]['name'],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'NetflixSans',
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
                  const SizedBox(height: 32),
                ]),

          )
            ],
          ),
        ),
      ),
    );
  }
}
