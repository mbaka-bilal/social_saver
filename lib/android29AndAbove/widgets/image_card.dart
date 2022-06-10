import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_storage/saf.dart' as saf;
import 'package:path/path.dart';

import 'package:social_saver/android29AndAbove/pages/single_item.dart';
import 'package:social_saver/android29AndAbove/providers/file_actions.dart';
import 'package:social_saver/download__manual_icons.dart';

/* class to display each image */

class ImageCard extends StatefulWidget {
  /* class for each image or video card */
  const ImageCard({
    Key? key,
    required this.info,
    required this.platform,
    required this.isLocalType,
    required this.index,
  }) : super(key: key);

  final saf.PartialDocumentFile info;
  final bool isLocalType;
  final int index;
  final String platform;

  // final bool downloaded;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _downloading = false;
  late Future<Uint8List> initializeImage;
  late String path;

  Future<Uint8List> setContent() async {
    Uint8List content =
        (await saf.getDocumentContent(widget.info.metadata!.uri!))!;
    return content;
  }

  void setPath() async {
    String baseName =
        basename((await saf.getRealPathFromUri(widget.info.metadata!.uri!))!);

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
    initializeImage = setContent();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<FileActions>(context, listen: false);

    return FutureBuilder(
        future: initializeImage,
        builder: (context, asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            if (asyncSnapShot.hasData) {
              Uint8List image = asyncSnapShot.data as Uint8List;

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SingleItem(
                                  image: image,
                                  type: widget.isLocalType,
                                  path: path,
                                )));
                  },
                  child: Stack(children: [
                    Card(
                      elevation: 30,
                      child: Image.memory(image),
                    ),
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
                                      uriSource: widget.info.metadata!.uri!);
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
                                padding: const EdgeInsets.only(
                                    bottom: 15.0, right: 10),
                                child: (_downloading)
                                    ? const CircularProgressIndicator()
                                    : CircleAvatar(
                                        radius: 17,
                                        backgroundColor:
                                            const Color(0xF26D6767),
                                        child: icon),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ]));
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
}
// }GestureDetector(
//   onTap: () {
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (BuildContext context) =>
//     //             SingleItem(path: widget.path, type: widget.isLocalType)));
//   },
//   child: Stack(
//     children: [
//       Card(
//         elevation: 30,
//         child: Image.memory(content),
//       ),
// FutureBuilder(
//     future: FileActions.checkFileDownloaded(
//         platform: widget.platform,
//         path: widget.path,
//         androidVersion: widget.androidVersion),
//     builder: (ctx, snapShot) {
//       if (snapShot.hasData) {
//         var data = snapShot.data as bool;
//
//         Widget _icon = const Icon(
//           Download_Manual.download,
//           color: Colors.white,
//           size: 20,
//         );
//
//         if (!widget.isLocalType && !data) {
//           _icon = GestureDetector(
//             onTap: () async {
//               if (data) {
//                 // print("in here buddy");
//                 setState(() {});
//                 null;
//               } else {
//                 // setState(() {
//                 //   // print("in set dstate");
//                 //   _downloading = true;
//                 // });
//
//                 if (widget.androidVersion < 28) {
//                   FileActions.saveFileSdkLess28(
//                       platform: widget.platform, path: widget.path);
//                 } else {
//                   FileActions.saveFile(
//                       platform: widget.platform, path: widget.path);
//                 }
//                 setState(() {
//                   _downloading = false;
//                 });
//
//                 // if (widget.index % 4 == 0) {
//                 //   var interstitialAd;
//                 //   setState(() {
//                 //     // print("in set dstate");
//                 //     _downloading = true;
//                 //   });
//                 //
//                 //   await InterstitialAd.load(
//                 //     adUnitId:
//                 //         "ca-app-pub-3940256099942544/8691691433",
//                 //     //"ca-app-pub-3940256099942544/1033173712",
//                 //     request: AdRequest(),
//                 //     adLoadCallback: InterstitialAdLoadCallback(
//                 //         onAdLoaded: (InterstitialAd ad) async {
//                 //       interstitialAd = ad;
//                 //       //handle full screen content
//                 //       interstitialAd.fullScreenContentCallback =
//                 //           FullScreenContentCallback(
//                 //         onAdShowedFullScreenContent:
//                 //             (InterstitialAd ad) {
//                 //           print('%ad onAdShowedFullScreenContent.');
//                 //         },
//                 //         onAdDismissedFullScreenContent:
//                 //             (InterstitialAd ad) {
//                 //           print(
//                 //               '$ad onAdDismissedFullScreenContent.');
//                 //
//                 //           FileActions.saveFile(
//                 //               platform: widget.platform,
//                 //               path: widget.path);
//                 //           setState(() {
//                 //             _downloading = false;
//                 //           });
//                 //           ad.dispose();
//                 //         },
//                 //         onAdFailedToShowFullScreenContent:
//                 //             (InterstitialAd ad, AdError error) {
//                 //           print(
//                 //               '$ad onAdFailedToShowFullScreenContent: $error');
//                 //
//                 //           FileActions.saveFile(
//                 //               platform: widget.platform,
//                 //               path: widget.path);
//                 //           setState(() {
//                 //             _downloading = false;
//                 //           });
//                 //           ad.dispose();
//                 //         },
//                 //         onAdImpression: (InterstitialAd ad) =>
//                 //             print('$ad impression occurred.'),
//                 //       );
//                 //       interstitialAd.show();
//                 //     }, onAdFailedToLoad: (LoadAdError error) {
//                 //       print("Error loading intersitialAd $error");
//                 //
//                 //       FileActions.saveFile(
//                 //           platform: widget.platform,
//                 //           path: widget.path);
//                 //       setState(() {
//                 //         _downloading = false;
//                 //       });
//                 //     }),
//                 //   );
//                 // } else {
//                 //   FileActions.saveFile(
//                 //       platform: widget.platform, path: widget.path);
//                 //   setState(() {
//                 //     _downloading = false;
//                 //   });
//                 // }
//               }
//             },
//             child: (_downloading)
//                 ? const CircularProgressIndicator()
//                 : const Icon(
//                     Download_Manual.download,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//           );
//         } else if (!widget.isLocalType && data) {
//           _icon = const Icon(
//             Icons.download_done,
//             color: Colors.white,
//             size: 20,
//           );
//         } else {
//           _icon = GestureDetector(
//             onTap: () {
//               _provider.deleteFile(widget.path);
//             },
//             child: const Icon(
//               Icons.delete,
//               color: Colors.red,
//               size: 20,
//             ),
//           );
//         }
//
//         return Positioned(
//           bottom: 0,
//           right: 0,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 15.0, right: 10),
//             child: (_downloading)
//                 ? const CircularProgressIndicator()
//                 : CircleAvatar(
//                     radius: 17,
//                     backgroundColor: const Color(0xF26D6767),
//                     child: _icon),
//           ),
//         );
//       } else {
//         return Container();
//       }
//     }),
//       ],
//     ),
//   ),
// );
//   }
// }
