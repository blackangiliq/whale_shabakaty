import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class film_video_player extends StatefulWidget {
  const film_video_player(
      {Key? key, required this.mediaType, required this.mediaId})
      : super(key: key);
  final String mediaType;
  final String mediaId;

  @override
  State<film_video_player> createState() => _film_video_playerState();
}

class _film_video_playerState extends State<film_video_player> {
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
    final jsonData = json.decode(response.body);
    if (mounted) {
      setState(() {
        videoSource = jsonData['videos'];
        subtitleSource = jsonData['subtitles'];
        BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          videoSource?[0]['url']?.toString().replaceAll("http", "https") ?? '',
          resolutions: {
            "${videoSource?[0]['quality']}": videoSource?[0]['url']
                    ?.toString()
                    .replaceAll("http", "https") ??
                '',
            "${videoSource?[1]['quality']}": videoSource?[1]['url']
                    ?.toString()
                    .replaceAll("http", "https") ??
                '',
            "${videoSource?[2]['quality']}": videoSource?[2]['url']
                    ?.toString()
                    .replaceAll("http", "https") ??
                '',
            "${videoSource?[3]['quality']}": videoSource?[3]['url']
                    ?.toString()
                    .replaceAll("http", "https") ??
                '',
          },
          subtitles: [
            BetterPlayerSubtitlesSource(
              selectedByDefault:
                  subtitleSource[0]['url'].toString().isNotEmpty ? true : false,
              type: BetterPlayerSubtitlesSourceType.network,
              urls: [
                subtitleSource[0]['url']
                        ?.toString()
                        .toString()
                        .replaceAll("http", "https") ??
                    ''
              ],
              name: subtitleSource[0]['language'],
            ),
            BetterPlayerSubtitlesSource(
              type: BetterPlayerSubtitlesSourceType.network,
              urls: [
                subtitleSource[1]['url']
                        ?.toString()
                        .toString()
                        .replaceAll("http", "https") ??
                    ''
              ],
              name: subtitleSource[1]['language'],
            ),
          ],
        );

        _betterPlayerController = BetterPlayerController(
            //subtitels style

            //make it auto play
            const BetterPlayerConfiguration(
              subtitlesConfiguration: //create subtitles configuration
                  BetterPlayerSubtitlesConfiguration(
                fontSize: 25,
                fontColor: Colors.white,
                fontFamily: 'OpenSans',
                backgroundColor: Colors.black,
                //enable subtitles
              ),
              //enable back button
              autoPlay: true,
              autoDispose: true,
              fullScreenByDefault: true,
              //ENABLE RUTATION
              deviceOrientationsAfterFullScreen: [
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
              controlsConfiguration: BetterPlayerControlsConfiguration(
                subtitlesIcon: Icons.subtitles,
                playbackSpeedIcon: Icons.speed,
                enableSkips: true,
                enableOverflowMenu: true,
                enableSubtitles: true,
                enablePlaybackSpeed: true,
                enableProgressText: true,
                enableRetry: true,
                enableAudioTracks: true,
                enableQualities: true,
                enableProgressBar: true,
                enableProgressBarDrag: true,
                showControlsOnInitialize: true,
                enableFullscreen: true,
                enablePlayPause: true,
                enableMute: false,
                enablePip: true,
              ),
            ),
            betterPlayerDataSource: betterPlayerDataSource);

        _betterPlayerController.stopPreCache(betterPlayerDataSource);
        isLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoaded
          ? const Center(child: CircularProgressIndicator())
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController,
              ),
            ),
    );
  }
}
