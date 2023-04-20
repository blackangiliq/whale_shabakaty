import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Better_plyaer extends StatefulWidget {
  const Better_plyaer(
      {Key? key, required this.mediaType, required this.mediaId})
      : super(key: key);
  final String mediaType;
  final String mediaId;
  @override
  State<Better_plyaer> createState() => _Better_plyaerState();
}

class _Better_plyaerState extends State<Better_plyaer> {
  late List videoSource;
  late List subtitleSource;
  bool isLoaded = true;

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  late BetterPlayerController _betterPlayerController;

  Future<void> _fetchVideoData() async {
    final response = await http.get(Uri.parse(
        'http://shasha.koolshy.co:8090/api/play?mediaType=${widget.mediaType}&mediaId=${widget.mediaId}&season=0&episode=0'));
    print('http://shasha.koolshy.co:8090/api/play?mediaType=${widget.mediaType}&mediaId=${widget.mediaId}&season=0&episode=0');
    final jsonData = json.decode(response.body);
   try{ if (mounted) {
     setState(() {
       videoSource = jsonData['videos'];
       print(videoSource);

       subtitleSource = jsonData['subtitles'];
       print(subtitleSource);
       if (videoSource != null && videoSource.isNotEmpty && subtitleSource.isNotEmpty && subtitleSource.isNotEmpty) {
         Map<String, String> resolutions = {};

         for (var video in videoSource) {
           if (video['quality'] != null && video['url'] != null) {
             resolutions["${video['quality']}"] = video['url'].toString().replaceAll("http", "https");
           }
         }

         List<BetterPlayerSubtitlesSource> subtitles = [];
         if(subtitleSource.isNotEmpty){
           for (var subtitle in subtitleSource) {
             if ( subtitle['url'] != null && subtitle['language'] != null) {
               subtitles.add(
                 BetterPlayerSubtitlesSource(
                   selectedByDefault: subtitle['url'].toString().isNotEmpty ? true : false,
                   type: BetterPlayerSubtitlesSourceType.network,
                   urls: [
                     subtitle['url'].toString().replaceAll("http", "https")
                   ],
                   name: subtitle['language'],
                 ),
               );
             }
           }
         }
         BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
           BetterPlayerDataSourceType.network,
           videoSource[1]['url']?.toString().replaceAll("http", "https") ?? '',
           bufferingConfiguration: const BetterPlayerBufferingConfiguration(
             minBufferMs: 1000,
             maxBufferMs: 2000,
             bufferForPlaybackMs: 1000,
             bufferForPlaybackAfterRebufferMs: 1000,
           ),
           resolutions: resolutions,
           subtitles: subtitles,
         );
         _betterPlayerController = BetterPlayerController(
             const BetterPlayerConfiguration(
               controlsConfiguration: BetterPlayerControlsConfiguration(
                 subtitlesIcon: Icons.subtitles,
                 playbackSpeedIcon: Icons.speed,
                 enableSkips: true,
                 enableFullscreen: true,
                 enablePlayPause: true,
                 enableMute: false,
                 enablePip: true,
               ),
             ),
             betterPlayerDataSource: betterPlayerDataSource);

         _betterPlayerController.stopPreCache(betterPlayerDataSource);
         isLoaded = false;
       } else {
         // Handle the case when videoSource or subtitleSource is empty or null
       }
     });
   }}catch(e){
     print(e);
   }
  }
  @override
  Widget build(BuildContext context) {
    return
      Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),

      },

      child:
      Scaffold(
        body: isLoaded
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              ),
      ),
    );
  }
}
