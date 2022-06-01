import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// import 'package:path/path.dart' as pathFile;
import 'package:saf/saf.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../providers/file_actions.dart';
import '../widgets/video_card.dart';
import '../widgets/image_card.dart';
import '../pages/instagram_page.dart';

class DisplayContent extends StatefulWidget {
  /* Show each individual image or video */
  const DisplayContent({Key? key, required this.type, required this.isLocal})
      : super(key: key);

  final String type;
  final bool isLocal;

  @override
  _DisplayContentState createState() => _DisplayContentState();
}

class _DisplayContentState extends State<DisplayContent> {
  int index = 0;

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var androidInfo;
  List<String> _filesList = [];
  var storagePath;

  Future<void> setExternalStoragePath() async {
    storagePath = await getExternalStorageDirectory();
  }

  Future<List<String>?> getPermission(String path) async {
    Saf saf = Saf(path);
    List<String>? paths = [];
    // print ("the path is ${saf}");
    // List<String>? availablePaths = await saf.getCachedFilesPath();
    await saf.getDirectoryPermission(isDynamic: false).catchError((err) {
      print("Unable to grant permission $err");
    });
    // await saf.cache()
    // print ("files path is ${await saf.cache()}");
    await saf.cache().then((e) {
      //it is cahce that works on and saf.getFilesPath()
      paths.addAll(e!);
    }).catchError((err) {
      print("Error using cache----------- $err");
    });
    return paths;
  }

  Future<void> getAndroidInfo() async {
    androidInfo = await deviceInfoPlugin.androidInfo;
  }

  Widget mainContent(List<String> filesList, String platform) {
    if (filesList.isNotEmpty && filesList != []) {
      /* if the list is not empty display the images */

      return SingleChildScrollView(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: filesList.map((e) {
            //return each item found in the path
            if (widget.type == "images") {
              index++;
              return ImageCard(
                isLocalType: widget.isLocal,
                path: e,
                platform: platform,
                index: index,
                androidVersion: androidInfo.version.sdkInt,
                // downloaded: false,
              );
            } else {
              index++;
              return VideoCard(
                isLocalType: widget.isLocal,
                path: e,
                platform: platform,
                androidVersion: androidInfo.version.sdkInt,
                index: index,
              );
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
    getAndroidInfo();
    setExternalStoragePath();
    // Saf.releasePersistedPermissions();
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

                //start setting the correct path
                if (!widget.isLocal) {
                  //if we are getting statuses
                  switch (_data) {
                    case "Whatsapp":
                      if (androidInfo.version.sdkInt >= 28) {
                        //if android version is equals or greater than version 9
                        _result =
                            "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                      } else {
                        _result = "WhatsApp/Media/.Statuses";
                      }
                      break;
                    case "businesswhatsapp":
                      if (androidInfo.version.sdkInt >= 28) {
                        _result =
                            "Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
                      } else {
                        _result = "WhatsApp Business/Media/.Statuses";
                      }
                      break;
                    case "gbwhatsapp":
                      if (androidInfo.version.sdkInt >= 28) {
                        _result = "GBWhatsApp/Media/.Statuses";
                      } else {
                        _result = "GBWhatsApp/Media/.Statuses";
                      }
                      break;
                    case " ":
                      if (androidInfo.version.sdkInt >= 28) {
                        //if android version is equals or greater than version 9
                        _result =
                            "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                      } else {
                        _result = "WhatsApp/Media/.Statuses";
                      }
                      break;
                    case "":
                      if (androidInfo.version.sdkInt >= 28) {
                        //if android version is equals or greater than version 9
                        _result =
                            "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                      } else {
                        _result = "WhatsApp/Media/.Statuses";
                      }
                      break;
                    default:
                      if (androidInfo.version.sdkInt >= 28) {
                        //if android version is equals or greater than version 9
                        _result =
                            "Android/media/com.whatsapp/WhatsApp/Media/.Statuses";
                      } else {
                        _result = "WhatsApp/Media/.Statuses";
                      }
                  }
                } else {
                  // if we are getting local saved files
                  switch (_data) {
                    case "Whatsapp":
                      _result = "/storage/emulated/0/saveit/Whatsapp/";
                      break;
                    case "businesswhatsapp":
                      _result = "/storage/emulated/0/saveit/businesswhatsapp/";
                      break;
                    case "gbwhatsapp":
                      _result = "/storage/emulated/0/saveit/gbwhatsapp/";
                      break;
                    case "instagram":
                      _result = "/storage/emulated/0/saveit/instagram/";
                      break;
                    case " ":
                      _result = "/storage/emulated/0/saveit/Whatsapp/";
                      break;
                    case "":
                      _result = "/storage/emulated/0/saveit/Whatsapp/";
                      break;
                    default:
                      _result = "/storage/emulated/0/saveit/Whatsapp/";
                  }
                }
                //end setting the correct path

                if (_data == "instagram" && !widget.isLocal) {
                  return const InstagramPage();
                }

                if (widget.isLocal) {
                  if (!Directory("$_result").existsSync()) {
                    return const Center(
                        child: Text(
                      "Noting Downloaded Yet",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ));
                  } else {
                    _filesList = Directory("$_result")
                        .listSync()
                        .map((item) => item.path)
                        .where((item) {
                      if (widget.type == "images") {
                        return item.endsWith(".jpg") || item.endsWith(".png");
                      } else {
                        return item.endsWith(".mp4") || item.endsWith(".3gp");
                      }
                    }).toList(growable: false);
                    return mainContent(_filesList, _data);
                  }
                } else {
                  // print("The search path is ${"/storage/emulated/0/$_result"}");
                  if (!Directory("/storage/emulated/0/$_result").existsSync()) {
                    return (_data == "instagram")
                        ? const Center(
                            child: Text(
                            "Nothing Downloaded Yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          ))
                        : Center(
                            child: Text(
                            "Please Install $_data",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          ));
                  } else {
                    if (androidInfo.version.sdkInt >= 28) {
                      //if android version 9 or above
                      return FutureBuilder(
                          //so the app does not start searching the directory until we fetch all the paths.
                          future: getPermission(_result),
                          builder: (ctx, snapShot) {
                            if (snapShot.hasData) {
                              List<String>? data =
                                  snapShot.data as List<String>?;
                              // print("the data is $data");
                              //remove any non wanted files
                              _filesList =
                                  data!.map((item) => item).where((item) {
                                if (widget.type == "images") {
                                  return item.endsWith(".jpg") ||
                                      item.endsWith(".png") ||
                                      item.endsWith("jpeg");
                                } else {
                                  return item.endsWith(".mp4") ||
                                      item.endsWith(".3gp");
                                }
                              }).toList(growable: false);
                              // print ("the fileList is $_filesList");
                              return mainContent(_filesList, _data);
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
                    } else {
                      //if android 8 or below
                      _filesList = Directory("/storage/emulated/0/$_result")
                          .listSync()
                          .map((item) => item.path)
                          .where((item) {
                        if (widget.type == "images") {
                          return item.endsWith(".jpg") || item.endsWith(".png");
                        } else {
                          return item.endsWith(".mp4") || item.endsWith(".3gp");
                        }
                      }).toList(growable: false);
                      return mainContent(_filesList, _data);
                    }
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
