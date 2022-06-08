// import 'dart:io';
// import 'dart:isolate';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path/path.dart';
// import 'package:shared_storage/saf.dart' as saf;
//
//
// import '../download__manual_icons.dart';
// import '../providers/file_actions.dart';
//
//
// class VideoCard extends StatefulWidget {
//   /* class for each image or video card */
//   const VideoCard({
//     Key? key,
//     required this.info,
//     required this.isLocalType,
//     required this.index,
//   }) : super(key: key);
//
//   final saf.PartialDocumentFile info;
//   final bool isLocalType;
//   final int index;
//
//   @override
//   State<VideoCard> createState() => _VideoCardState();
// }
//
// class _VideoCardState extends State<VideoCard> {
//   bool _downloading = false;
//   late Future<String?> future;
//
//   // Future<String> generateThumbnail(saf.PartialDocumentFile videoData) async {
//   //   /* generate the thumbnail */
//   //
//   //   String? path = await saf.getRealPathFromUri(videoData.metadata!.uri!);
//   //
//   //   Uint8List content =
//   //   (await saf.getDocumentContent(widget.info.metadata!.uri!))!;
//   //
//   //   VideoThumbnail.thumbnailData(video: content)
//   //
//   //   WidgetsFlutterBinding.ensureInitialized();
//   //   // String? thumbnail;
//   //   // String? thumbnailPath = join((await getApplicationDocumentsDirectory()).path,
//   //   //     basename(path!.replaceAll(".mp4", ".jpg")));
//   //   // if (!File(thumbnailPath).existsSync()) {
//   //   //   await VideoThumbnail.thumbnailFile(
//   //   //       video: path,
//   //   //       thumbnailPath: (await getApplicationDocumentsDirectory()).path,
//   //   //       imageFormat: ImageFormat.JPEG,
//   //   //       quality: 100);
//   //   // } else {
//   //   //
//   //   // }
//   //   // return thumbnail;
//   // }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     // future = generateThumbnail(widget.info);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _provider = Provider.of<FileActions>(context, listen: false);
//     return FutureBuilder(
//         future: future,
//         builder: (ctx, snapShot) {
//           if (snapShot.hasData) {
//             String? _path = snapShot.data as String?;
//
//             return Stack(
//               children: [
//                 Card(
//                   elevation: 30,
//                   child: Image.file(
//                     File(_path!),
//                   ),
//                 ),
//                 FutureBuilder(
//                     future: FileActions.checkFileDownloaded(
//                         platform: widget.platform,
//                         path: widget.path,
//                         androidVersion: widget.androidVersion),
//                     builder: (ctx, snapShot) {
//                       if (snapShot.hasData) {
//                         var data = snapShot.data as bool;
//
//                         Widget _icon = const Icon(
//                           //the default icon to show
//                           Download_Manual.download,
//                           color: Colors.white,
//                           size: 20,
//                         );
//
//                         if (!widget.isLocalType && !data) {
//                           //if it is not of type local and it has not been downloaded
//                           _icon = GestureDetector(
//                             onTap: () async {
//                               if (data) {
//                                 // print("in here buddy");
//                                 setState(() {});
//                                 null;
//                               } else {
//                                 if (widget.androidVersion < 28) {
//                                   FileActions.saveFileSdkLess28(
//                                       platform: widget.platform,
//                                       path: widget.path);
//                                 } else {
//                                   FileActions.saveFile(
//                                       platform: widget.platform,
//                                       path: widget.path);
//                                 }
//                                 setState(() {
//                                   _downloading = false;
//                                 });
//                               }
//                             },
//                             child: (_downloading)
//                                 ? const CircularProgressIndicator()
//                                 : const Icon(
//                                     Download_Manual.download,
//                                     color: Colors.white,
//                                     size: 20,
//                                   ),
//                           );
//                         } else if (!widget.isLocalType && data) {
//                           // if it is not of type local and is has been downloaded
//                           _icon = const Icon(
//                             Icons.download_done,
//                             color: Colors.white,
//                             size: 20,
//                           );
//                         } else {
//                           // if it is not in local and it has not been downloaded
//                           _icon = GestureDetector(
//                             onTap: () {
//                               _provider.deleteFile(widget.path);
//                             },
//                             child: const Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                               size: 20,
//                             ),
//                           );
//                         }
//
//                         return Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(bottom: 25.0, right: 10),
//                             child: CircleAvatar(
//                               radius: 17,
//                               backgroundColor: const Color(0xF26D6767),
//                               child: (_downloading)
//                                   ? const CircularProgressIndicator()
//                                   : CircleAvatar(
//                                       radius: 17,
//                                       backgroundColor: const Color(0xF26D6767),
//                                       child: _icon),
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Container();
//                       }
//                     }),
//                 Positioned.fill(
//                     child: Align(
//                   alignment: Alignment.center,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => PlayVideo(
//                                     videoPath: widget.path,
//                                     type: widget.isLocalType,
//                                   )));
//                     },
//                     child: ClipRRect(
//                         child: Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           border: Border.all(color: Colors.white, width: 3)),
//                       child: const Icon(
//                         Icons.play_arrow_outlined,
//                         color: Colors.white,
//                       ),
//                     )),
//                   ),
//                 ))
//               ],
//             );
//           } else if (snapShot.hasError) {
//             // print("There is error ${snapShot.error}");
//             return const Align(
//                 alignment: Alignment.center, child: Text("Unknown Error"));
//           } else {
//             return const Align(
//               alignment: Alignment.center,
//               // child: CircularProgressIndicator()
//             );
//             // );
//           }
//         });
//   }
// }
