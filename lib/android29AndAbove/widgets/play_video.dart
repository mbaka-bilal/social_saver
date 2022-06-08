import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_storage/saf.dart' as saf;

import '../providers/file_actions.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({Key? key, required this.videoInfo, required this.type})
      : super(key: key);

  final saf.PartialDocumentFile videoInfo;
  final bool type;

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieController;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _controller =
        VideoPlayerController.contentUri(widget.videoInfo.metadata!.uri!);
    // _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.value
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        fullScreenByDefault: false,
        systemOverlaysAfterFullScreen: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp
        ]);

    // _chewieController.addListener(() {

    // });

    _controller.addListener(() async {
      if (_chewieController.isPlaying && !_chewieController.isFullScreen) {
        _chewieController.enterFullScreen();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.removeListener(() { })
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          if (snapShot.hasError) {
            print("Error while processing video ${snapShot.error}");
            return Container();
          }

          return SizedBox(
            width: 200,
            height: 300,
            child: Stack(children: [
              Align(
                  alignment: Alignment.center,
                  child: Chewie(controller: _chewieController)),
            ]),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
