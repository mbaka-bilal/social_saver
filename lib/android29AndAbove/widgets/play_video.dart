import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:social_saver/download__manual_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_storage/saf.dart' as saf;
import 'package:path/path.dart';

import '../providers/file_actions.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo(
      {Key? key,
      required this.videoInfo,
      required this.isLocalType,
      required this.platform})
      : super(key: key);

  final saf.PartialDocumentFile videoInfo;
  final bool isLocalType;
  final String platform;

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late ChewieController _chewieController;
  late String path;

  void setPath() async {
    String baseName = basename(
        (await saf.getRealPathFromUri(widget.videoInfo.metadata!.uri!))!);

    // print ("the basename is ${widget.platform}");

    if (widget.platform == "Whatsapp") {
      path = "/storage/emulated/0/Download/saveit/Whatsapp/$baseName";
    } else {
      path = "/storage/emulated/0/Download/saveit/Whatsapp/$baseName";
    }
  }

  @override
  void initState() {
    super.initState();
    setPath();
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
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
              FutureBuilder(
                  future: FileActions.checkFileDownloaded(path: path),
                  builder: (ctx, asyncSnapShot) {
                    if (asyncSnapShot.hasData) {
                      bool fileExists = asyncSnapShot.data as bool;

                      Widget icon = Container();

                      if (!widget.isLocalType && !fileExists) {
                        icon = GestureDetector(
                          onTap: () async {
                            FileActions.saveFile(
                                platformName: "Whatsapp",
                                uriSource: widget.videoInfo.metadata!.uri!);
                            setState(() {});
                          },
                          child: const Icon(
                            Download_Manual.download,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      } else if (!widget.isLocalType && fileExists) {
                        icon = const Icon(
                          Icons.download_done,
                          color: Colors.white,
                          size: 20,
                        );
                      } else {
                        icon = GestureDetector(
                          onTap: () {
                            _provider.deleteFile(path);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        );
                      }

                      return Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, right: 10),
                          child: CircleAvatar(
                              radius: 17,
                              backgroundColor: const Color(0xF26D6767),
                              child: icon),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
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
