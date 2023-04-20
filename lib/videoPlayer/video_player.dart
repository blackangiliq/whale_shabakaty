// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:subtitle_wrapper_package/subtitle_controller.dart';
// import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
// import 'package:video_player/video_player.dart';
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: <LogicalKeySet, Intent>{
//         LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
//       },
//       child: Actions(
//         actions: <Type, Action<Intent>>{
//           ActivateIntent: CallbackAction<ActivateIntent>(
//             onInvoke: (ActivateIntent intent) {
//               print('onInvoke');
//             },
//           ),
//         },
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Video Player Demo',
//           theme: ThemeData.dark(),
//           home: VideoPlayerScreen(),
//         ),
//       ),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   // Define the current position and duration of the video
//   Duration _currentPosition = Duration.zero;
//   Duration _duration = Duration.zero;
//   String nextVideo =
//       'https://storage.koolshy.com/shasha-transcoded-videos-2019/fbd46004-6c93-47ac-a52c-35d7ea63ab01_1080.mp4';
//   final SubtitleController subtitleController = SubtitleController(
//     subtitleUrl:
//     "https://storage.koolshy.com/shasha-subtitles-2019/d8717103-a359-41e7-b133-a47c9ca7450e.vtt",
//     subtitleType: SubtitleType.webvtt,
//   );
//   bool loaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'https://storage.koolshy.com/shasha-transcoded-videos-2019/fbd46004-6c93-47ac-a52c-35d7ea63ab01_1080.mp4');
//     _initializeVideoPlayerFuture = _controller.initialize();
//     // Add a listener to update the current position and duration of the video
//     _controller.addListener(() {
//       setState(() {
//         _currentPosition = _controller.value.position;
//         _duration = _controller.value.duration;
//         _controller.play();
//         loaded = true;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
// // Helper method to format duration as a string
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return loaded
//         ? Stack(
//       children: [
//         SubtitleWrapper(
//           videoPlayerController: _controller,
//           subtitleController: subtitleController,
//           subtitleStyle: const SubtitleStyle(
//             textColor: Colors.white,
//             hasBorder: true,
//           ),
//           videoChild: VideoPlayer(_controller),
//         ),
//         // Positioned(
//         //   bottom: 0,
//         //   left: 0,
//         //   right: 0,
//         //   child: Column(
//         //     children: [
//         //       Row(
//         //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //         children: [
//         //           Expanded(
//         //             child: VideoProgressIndicator(
//         //               _controller,
//         //               allowScrubbing: true,
//         //               colors: const VideoProgressColors(
//         //                 playedColor: Colors.red,
//         //                 bufferedColor: Colors.grey,
//         //                 backgroundColor: Colors.black,
//         //               ),
//         //             ),
//         //           ),
//         //           Text(
//         //             formatDuration(_duration - _currentPosition),
//         //             style: const TextStyle(color: Colors.white),
//         //           ),
//         //         ],
//         //       ),
//         //       Row(
//         //         mainAxisAlignment: MainAxisAlignment.center,
//         //         children: [
//         //           IconButton(
//         //             onPressed: () {
//         //               // Seek back 10 seconds
//         //               _controller.seekTo(_currentPosition -
//         //                   const Duration(seconds: 10));
//         //             },
//         //             icon: const Icon(Icons.replay_10,
//         //                 color: Colors.white),
//         //           ),
//         //           const SizedBox(width: 16),
//         //           IconButton(
//         //             onPressed: () {
//         //               if (_controller.value.isPlaying) {
//         //                 _controller.pause();
//         //               } else {
//         //                 _controller.play();
//         //               }
//         //             },
//         //             icon: Icon(
//         //                 _controller.value.isPlaying
//         //                     ? Icons.pause
//         //                     : Icons.play_arrow,
//         //                 color: Colors.white),
//         //           ),
//         //           const SizedBox(width: 16),
//         //           IconButton(
//         //             onPressed: () {
//         //               // Seek forward 10 seconds
//         //               _controller.seekTo(_currentPosition +
//         //                   const Duration(seconds: 10));
//         //             },
//         //             icon: const Icon(Icons.forward_10,
//         //                 color: Colors.white),
//         //           ),
//         //           const SizedBox(width: 16),
//         //           IconButton(
//         //             icon: const Icon(Icons.skip_previous,
//         //                 color: Colors.white),
//         //             onPressed: () {
//         //               // Navigate to the previous video
//         //             },
//         //           ),
//         //           //go to next video
//         //           IconButton(
//         //             icon: const Icon(Icons.skip_next,
//         //                 color: Colors.white),
//         //             onPressed: () {
//         //               _controller
//         //                   .pause(); // Pause the current video before navigating to the next one
//         //               _controller = VideoPlayerController.network(
//         //                   nextVideo); // Create a new VideoPlayerController for the next video
//         //               _initializeVideoPlayerFuture =
//         //                   _controller.initialize();
//         //               // Add a listener to update the current position and duration of the video
//         //               _controller.addListener(() {
//         //                 setState(() {
//         //                   _currentPosition = _controller.value.position;
//         //                   _duration = _controller.value.duration;
//         //                 });
//         //               });
//         //               setState(
//         //                   () {}); // Update the UI with the new video player
//         //             },
//         //           ),
//         //           IconButton(
//         //             icon: const Icon(Icons.closed_caption,
//         //                 color: Colors.white),
//         //             onPressed: () {
//         //               // Navigate to the next video
//         //             },
//         //           ),
//         //         ],
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
