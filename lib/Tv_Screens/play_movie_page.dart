// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
// import 'package:subtitle_wrapper_package/subtitle_controller.dart';
// import 'package:subtitle_wrapper_package/subtitle_wrapper.dart';
// import 'package:video_player/video_player.dart';
//
// class PlayPage extends StatefulWidget {
//   final String mediaType;
//   final String mediaId;
//
//   PlayPage({required this.mediaType, required this.mediaId});
//
//   @override
//   _PlayPageState createState() => _PlayPageState();
// }
//
// class _PlayPageState extends State<PlayPage> {
//   Duration _currentPosition = Duration.zero;
//   Duration _duration = Duration.zero;
//   late VideoPlayerController _controller;
//   bool _loading = false;
//   late SubtitleController subtitleController;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchVideoData();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   Future<void> _fetchVideoData() async {
//     final response = await http.get(Uri.parse(
//         'http://shasha.koolshy.co:8090/api/play?mediaType=${widget.mediaType}&mediaId=${widget.mediaId}&season=0&episode=0'));
//     final jsonData = json.decode(response.body);
//     if (mounted) {
//       setState(() {
//         _controller = VideoPlayerController.network(
//             jsonData['videos']?[0]['url']?.toString().replaceAll("http", "https") ?? ''
//         ) ..initialize().then((_) {
//           subtitleController = SubtitleController(
//             subtitleUrl: jsonData['subtitles']?[0]['url']
//                 ?.toString()
//                 ?.replaceAll("http", "https")
//                 ?? '',
//             subtitleType: SubtitleType.webvtt,
//           );
//           if (_controller.value.isInitialized) {
//             setState(() {
//               _loading = true;
//               _duration = _controller.value.duration;
//               _controller.addListener(() {
//                 setState(() {
//                   _currentPosition = _controller.value.position;
//                 });
//               });});}});
//       });}}
//   Timer? _timer;
//   void _playPause() {
//     setState(() {
//       if (_isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       _isPlaying = !_isPlaying;
//     });
//   }
//
//   void _seekForward(int time) {
//     setState(() {
//       _controller.seekTo(_controller.value.position + Duration(seconds: time));
//     });
//   }
//
//   void _seekBackward(int time) {
//     setState(() {
//       _controller.seekTo(_controller.value.position - Duration(seconds: time));
//     });
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
//   Widget _buildPlayPauseButton() {
//     IconData iconData = _isPlaying ? Icons.pause : Icons.play_arrow;
//     return FloatingActionButton(
//       //change the size of the button
//       mini: true,
//       onPressed: _playPause,
//       backgroundColor: _isPlaying ? Colors.green : Colors.grey,
//       autofocus: true,
//       focusColor: Colors.amber,
//       child: Icon(iconData),
//     );
//   }
//
//   Widget _buildTimeline() {
//     return Expanded(
//       child: VideoProgressIndicator(
//         _controller,
//         allowScrubbing: true,
//         colors: VideoProgressColors(
//           playedColor: Colors.red,
//           bufferedColor: Colors.grey,
//           backgroundColor: Colors.black38,
//         ),
//       ),
//     );
//   }
//
//   late bool _showSubtitle = true;
//
//   Widget _buildVideoControls() {
//     return Container(
//       color: Colors.black.withOpacity(0.7),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildPlayPauseButton(),
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   setState(() {
//                     _controller.seekTo(Duration.zero);
//                   });
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(Icons.stop_circle),
//               ),
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   _seekBackward(10);
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(Icons.replay_10),
//               ),
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   _seekForward(10);
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(Icons.forward_10),
//               ),
//               const SizedBox(width: 8.0),
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   _seekBackward(60 * 3);
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(Icons.arrow_circle_left_outlined),
//               ),
//               //floating action button to to seek forward 10 minutes
//
//               const SizedBox(width: 8.0),
//               //floating action button to to seek backward 10 minutes
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   _seekForward(60 * 3);
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(Icons.arrow_circle_right_outlined),
//               ),
//               const SizedBox(width: 8.0),
//
//               //show subtitle FloatingActionButton
//               FloatingActionButton(
//                 //change the size of the button
//                 mini: true,
//                 onPressed: () {
//                   setState(() {
//                     _showSubtitle = !_showSubtitle;
//                   });
//                 },
//                 backgroundColor: Colors.grey,
//                 autofocus: true,
//                 focusColor: Colors.amber,
//                 child: Icon(
//                     _showSubtitle ? Icons.subtitles : Icons.closed_caption,
//                     color: _showSubtitle ? Colors.white : Colors.grey),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               const SizedBox(width: 8.0),
//               Text(
//                 "${_formatDuration(_currentPosition)} / ${_formatDuration(_duration)}",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12.0,
//                 ),
//               ),
//               _buildTimeline(),
//               const SizedBox(width: 8.0),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   bool showControls = true;
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: <LogicalKeySet, Intent>{
//         LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
//
//       },
//       child: Scaffold(
//         body: _loading
//             ? RawKeyboardListener(
//           focusNode: FocusNode(),
//           onKey: (event) {
//             if (event is RawKeyDownEvent &&
//                 event.logicalKey == LogicalKeyboardKey.enter ) {
//               setState(() {
//                 showControls = true;
//               });
//               _startTimer();
//             }
//             if(event is RawKeyDownEvent &&
//                 event.logicalKey == LogicalKeyboardKey.arrowDown ){
//               setState(() {
//                 showControls = true;
//               });
//               _startTimer();
//             }
//             if(event is RawKeyDownEvent &&
//                 event.logicalKey == LogicalKeyboardKey.arrowUp ){
//               setState(() {
//                 showControls = true;
//               });
//               _startTimer();
//             }
//             if(event is RawKeyDownEvent &&
//                 event.logicalKey == LogicalKeyboardKey.arrowLeft ){
//               setState(() {
//                 showControls = true;
//               });
//               _startTimer();
//             }
//             if(event is RawKeyDownEvent &&
//                 event.logicalKey == LogicalKeyboardKey.arrowRight ){
//               setState(() {
//                 showControls = true;
//               });
//               _startTimer();
//             }
//           },
//           child: Stack(
//             children: [
//               SubtitleWrapper(
//                 videoPlayerController: _controller,
//                 subtitleController: subtitleController,
//                 subtitleStyle: SubtitleStyle(
//                   textColor:
//                   _showSubtitle ? Colors.white : Colors.transparent,
//                   fontSize: 22,
//                   hasBorder: true,
//                 ),
//                 videoChild: VideoPlayer(_controller),
//               ),
//               if (showControls)
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: _buildVideoControls(),
//                 ),
//             ],
//           ),
//         )
//             : const Center(child: Text("جاري تحميل الفيديو")),
//       ),
//     );
//   }
//
//   void _startTimer() {
//     const timeout = Duration(seconds: 3);
//     _timer?.cancel(); // cancel previous timer if any
//     _timer = Timer(timeout, () {
//       setState(() {
//         showControls = false;
//       });
//     });
//   }
//
//
// }
