import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_storage/saf.dart' as saf;
import 'package:social_saver/android29AndAbove/widgets/play_video.dart';
import 'package:social_saver/android29AndAbove/widgets/video_card.dart';
import 'package:social_saver/android29AndAbove/pages/instagram_page.dart';
import 'package:social_saver/android29AndAbove/providers/file_actions.dart';
import 'package:social_saver/android29AndAbove/widgets/image_card.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class DisplayContentSaf extends StatefulWidget {
  /* Show each individual image or video */
  const DisplayContentSaf({Key? key, required this.type, required this.isLocal})
      : super(key: key);

  final String type;
  final bool isLocal;

  @override
  _DisplayContentSafState createState() => _DisplayContentSafState();
}

class _DisplayContentSafState extends State<DisplayContentSaf> {
  int index = 0;

  Future<List<saf.PartialDocumentFile>> getAllFilesSaf(Uri uri) async {
    List<String>? _paths = [];
    final List<saf.PartialDocumentFile> files = [];
    const List<saf.DocumentFileColumn> columns = <saf.DocumentFileColumn>[
      saf.DocumentFileColumn.mimeType
    ];

    if (!(await saf.isPersistedUri(uri))) {
      /* if URI permission has not been granted */
      await saf.openDocumentTree(initialUri: uri);
    }

    if (await saf.canRead(uri) ?? true) {
    } else {
      await saf.openDocumentTree(initialUri: uri);
    }

    //read all files in the current directory

    final saf.DocumentFile? documentFileOfMyGrantedUri =
        await uri.toDocumentFile();
    final Stream<saf.PartialDocumentFile> onNewFileLoaded =
        documentFileOfMyGrantedUri!.listFiles(columns);
    await for (var element in onNewFileLoaded) {
      files.add(element);
    }

    return files;
  }

  Widget mainContent(List<saf.PartialDocumentFile> filesList, String platform) {
    if (filesList.isNotEmpty && filesList != []) {
      /* if the list is not empty display the images */

      return SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: filesList.map((e) {
            if (widget.type == "images") {
              return ImageCard(
                  platform: platform,
                  info: e,
                  isLocalType: widget.isLocal,
                  index: index);
            } else {
              return PlayVideo(
                  videoInfo: e,
                  isLocalType: widget.isLocal,
                  platform: platform);
              // return VideoCard(info: e,isLocalType: widget.isLocal, index: index);
            }
          }).toList(),
        ),
      );
    } else {
      return Container(
        // height: constraints.maxHeight,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/send_background.jpg"))),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileActions>(builder: (ctx, provider, _) {
      Future<String?> getPath() async {
        await provider.getSharedPreferences();
        var _check = provider.getSelectedPlatform();
        return _check;
      }

      return FutureBuilder(
          future: getPath(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasData) {
                var _data = snapShot.data as String;
                String _result = "";

                //TODO set the Correct URI for each platform

                if (_data == "instagram" && !widget.isLocal) {
                  // return const InstagramPage();
                }

                //start setting the correct path
                if (widget.isLocal) {
                  //if we are getting saved statuses

                  // switch (_data) {
                  //   case "Whatsapp":
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       //if android version is equals or greater than version 9
                  //       _result =
                  //       "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                  //     } else {
                  //       _result = "WhatsApp/Media/.Statuses";
                  //     }
                  //     break;
                  //   case "businesswhatsapp":
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       _result =
                  //       "Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
                  //     } else {
                  //       _result = "WhatsApp Business/Media/.Statuses";
                  //     }
                  //     break;
                  //   case "gbwhatsapp":
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       _result = "GBWhatsApp/Media/.Statuses";
                  //     } else {
                  //       _result = "GBWhatsApp/Media/.Statuses";
                  //     }
                  //     break;
                  //   case " ":
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       //if android version is equals or greater than version 9
                  //       _result =
                  //       "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                  //     } else {
                  //       _result = "WhatsApp/Media/.Statuses";
                  //     }
                  //     break;
                  //   case "":
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       //if android version is equals or greater than version 9
                  //       _result =
                  //       "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                  //     } else {
                  //       _result = "WhatsApp/Media/.Statuses";
                  //     }
                  //     break;
                  //   default:
                  //     if (androidInfo.version.sdkInt >= 28) {
                  //       //if android version is equals or greater than version 9
                  //       _result =
                  //       "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                  //     } else {
                  //       _result = "WhatsApp/Media/.Statuses";
                  //     }
                  // }
                } else {
                  /* if we want to see recently viewed data */
                  Uri uri;

                  //TODO add more URI's

                  switch (_data) {
                    //TODO update the result to the correct path
                    case "Whatsapp":
                      uri = Uri.parse(
                          'content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fmedia%2Fcom.whatsapp%2FWhatsApp%2FMedia%2F.Statuses');
                      break;
                    default:
                      uri = Uri.parse(
                          'content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fmedia%2Fcom.whatsapp%2FWhatsApp%2FMedia%2F.Statuses');
                  }

                  if (!Directory("/storage/emulated/0/$_result").existsSync()) {
                    /* Check if directory exists, so we can know if the app is installed */

                    return Center(
                        child: Text(
                      "Please Install $_data",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins"),
                    ));
                  } else {
                    /* if the directory exist we look at it */

                    return FutureBuilder(
                        //so the app does not start searching the directory until we fetch all the paths.
                        future: getAllFilesSaf(uri),
                        builder: (ctx, snapShot) {
                          if (snapShot.hasData) {
                            List<saf.PartialDocumentFile> data =
                                snapShot.data as List<saf.PartialDocumentFile>;

                            List<saf.PartialDocumentFile> dataImages = [];
                            List<saf.PartialDocumentFile> dataVideos = [];

                            /* TO know if we are looking for images or videos */

                            if (widget.type == 'images') {
                              for (var element in data) {
                                final mimeType = element
                                        .data![saf.DocumentFileColumn.mimeType]
                                    as String?;

                                if (mimeType!.startsWith("image/")) {
                                  dataImages.add(element);
                                }
                              }
                            } else {
                              for (var element in data) {
                                // print ("checking for videos");
                                final mimeType = element
                                        .data![saf.DocumentFileColumn.mimeType]
                                    as String?;
                                if (mimeType!.startsWith("video/")) {
                                  // print ("the mimeType is ${mimeType}");
                                  // String path = await saf.getRealPathFromUri(element.metadata!.uri!);
                                  // generateThumbnail(element);
                                  dataVideos.add(element);
                                }
                              }
                              // print ("the length of videos is ${dataVideos.length}");
                            }
                            return (widget.type == "images")
                                ? mainContent(dataImages, _data)
                                : mainContent(dataVideos, _data);
                          } else if (snapShot.hasError) {
                            print("Error ${snapShot.error}");
                            return Container();
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            );
                          }
                        });
                  }
                }
              } else if (snapShot.hasError) {
                print("error in first future builder ${snapShot.error}");
                return const Text("Error!!");
              }
            } else {
              //not connected yet waiting, show the progress indicator
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              );
            }
            return const Center(
                child: Text(
              "Please Select a Platform",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ));
          });
    });
  }
}
