import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathFile;

// import 'package:saf/saf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_storage/saf.dart' as saf;

class FileActions with ChangeNotifier {
  String? _platform = " ";

  // static late Saf saf;

  Future<void> getSharedPreferences() async {
    /* get the currently selected platform */
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    _platform = await _sharedPreferences.getString("activePlatform");
  }

  String? getSelectedPlatform() {
    return _platform;
  }

  void setSelectedPlatform(String platformName) async {
    SharedPreferences _sharedPreferences =
    await SharedPreferences.getInstance();
    await _sharedPreferences.setString("activePlatform", platformName);
    notifyListeners();
  }

  static void saveFile(
      {required Uri uriSource, required String platformName}) async {
    // print ("the source directory is ${await saf.getRealPathFromUri(uriSource)}");
    //storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses/eb6dbe0d099040b4a2b719521ba43657.jpg

    var _baseName =
        pathFile.basename((await saf.getRealPathFromUri(uriSource))!);

    // print ("the basename is $_baseName");

    if (!Directory("/storage/emulated/0/Download/saveit/$platformName")
        .existsSync()) {
      Directory("/storage/emulated/0/Download/saveit/$platformName")
          .createSync();
    }

    Uint8List data = (await saf.getDocumentContent(uriSource))!;
    //Get the bytes from the Whatsapp Directory,

    File _file = await File(
            "/storage/emulated/0/Download/saveit/$platformName/$_baseName")
        .create();

    // print (_file.path);
    //storage/emulated/0/Download/saveit/Whatsapp/eb6dbe0d099040b4a2b719521ba43657.jpg

    try {
      if ((_file.existsSync())) {
        print("it exists ");
        //This returns true but nothing displays in the directory
      } else {
        _file.writeAsBytesSync(data);
      }
    } catch (e) {
      //And does not return any error, the code dosen't reach here
      print("Error coiyg $e");
    }
    //
    // _file.copySync("/storage/emulated/0/Download/saveit/$platformName/$_baseName");
  }

  static Future<bool> checkFileDownloaded({required String path}) async {
    // check if a file has already been downloaded

    File _file = File(path);

    if (_file.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  void deleteFile(String path) {
    /* delete a file */
    File _filePath = File(path);
    _filePath.deleteSync();
    notifyListeners();
  }
}
