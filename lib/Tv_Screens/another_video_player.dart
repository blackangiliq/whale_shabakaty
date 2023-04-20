// import 'dart:convert';
//
// import 'package:fijkplayer/fijkplayer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
// class VideoScreen extends StatefulWidget {
//   final String mediaType;
//   final String mediaId;
//   VideoScreen({required this.mediaId , required this.mediaType});
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   final FijkPlayer player = FijkPlayer();
//
//   _VideoScreenState();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchVideoData();
//   }
//
//   Future<void> _fetchVideoData() async {
//
//     final response = await http.get(Uri.parse(
//         'http://shasha.koolshy.co:8090/api/play?mediaType=${widget.mediaType}&mediaId=${widget.mediaId}&season=0&episode=0'));
//     final jsonData = json.decode(response.body);
//     if (mounted) {
//       setState(() {
//         player.setDataSource(jsonData['videos']?[0]['url']?.toString().replaceAll("http", "https") ?? '', autoPlay: true);
//       });
//     }}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         body: Container(
//           alignment: Alignment.center,
//           child: FijkView(
//
//             player: player,
//           ),
//         ));
//   }
//
//   @override
//   void dispose() {
//     print("dispose");
//     super.dispose();
//     player.release();
//   }
// }