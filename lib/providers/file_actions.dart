import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathFile;
import 'package:saf/saf.dart';
import 'package:path_provider/path_provider.dart';

class FileActions with ChangeNotifier {
  String? _platform = " ";
  static late Saf saf;
  static var androidInfo;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

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

  static void saveFileSdkLess28(
      {required String platform, required String path}) async {
    //method to save file if android version is android 8.0 or less

    //TODO check for storage space left.
    //TODO implement external storage.

    var _baseName = pathFile.basename(path);

    if (!Directory("/storage/emulated/0/saveit").existsSync()) {
      Directory("/storage/emulated/0/saveit").createSync();
    } else {
      if (!Directory("/storage/emulated/0/saveit/$platform").existsSync()) {
        Directory("/storage/emulated/0/saveit/$platform").createSync();
      } else {
        File _file = File(path);
        await _file.copy(
            "/storage/emulated/0/saveit/$platform/$_baseName"); //copy the file to the new directory
      }
    }
  }

  static void saveFile({required String platform, required String path}) async {
    /* move files to permanent storage */

    //TODO check for storage space left.

    var _baseName = pathFile.basename(path);

    var appPath = await getExternalStorageDirectory();
    if (!Directory("${appPath!.path}/$platform").existsSync()) {
      //create the directory if it dosen't exist yet
      Directory("${appPath.path}/$platform")
          .createSync(recursive: true);
    }
    File _file = File(path);
    await _file.copy("${appPath.path}/$platform/$_baseName"); //copy the file to the new directory
  }

  static Future<bool> checkFileDownloaded(
      {required String platform,
      required String path,
      required int androidVersion}) async {
    // check if a file has already been downloaded
    String _result = "";
    var appPath = await getExternalStorageDirectory();

    if (androidVersion < 28) {
      switch (platform) {
        case "Whatsapp":
          _result = "/storage/emulated/0/saveit/whatsapp/";
          break;
        case "businesswhatsapp":
          _result = "/storage/emulated/0/saveit/businesswhatsapp/";
          break;
        case "gbwhatsapp":
          _result = "/storage/emulated/0/saveit/gbwhatsapp/";
          break;
        case "instagram":
          _result = "/storage/emulated/0/saveit/whatsapp/";
          break;
        default:
          _result = "/storage/emulated/0/saveit/whatsapp/";
      }
    } else {
      switch (platform) {
        case "Whatsapp":
          _result = "${appPath!.path}/whatsapp/";
          break;
        case "businesswhatsapp":
          _result = "${appPath!.path}/businesswhatsapp/";
          break;
        case "gbwhatsapp":
          _result = "${appPath!.path}/gbwhatsapp/";
          break;
        case "instagram":
          _result = "${appPath!.path}/whatsapp/";
          break;
        default:
          _result = "${appPath!.path}/whatsapp/";
      }
    }

    if (File(_result + pathFile.basename(path)).existsSync()) {
      return true;
    } else {
      // print ("File does not exists");
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
