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

  static void saveFile({required String platform, required String path}) async {

    // print ("in save file $platform");

    var _baseName = pathFile.basename(path);
    String _path = "";

    if (!(Directory("/storage/emulated/0/Download/saveit/").existsSync())) {
      // print ("file does not exists");
      Directory("/storage/emulated/0/Download/saveit/").createSync();
    }

    switch (platform) {
      case "businesswhatsapp":
        _path = "/storage/emulated/0/Download/saveit/businesswhatsapp/";
        break;
      case "Whatsapp":
        _path = "/storage/emulated/0/Download/saveit/Whatsapp/";
        break;
      case "gbwhatsapp":
        _path = "/storage/emulated/0/Download/saveit/gbwhatsapp/";
        break;
    }

    if (!(Directory(_path)
        .existsSync())) {
      // print ("path does not exists");
      Directory(_path).createSync();
    }

    // String _filePath = join()

    File _file = File(path); //check if the file exists
    if (!(File(pathFile.join(_path,_baseName)).existsSync())) {
      await _file.copy(pathFile.join(_path,_baseName)); //copy the file to the new directory
    }
  }

  // static void saveFile({required String platform, required String path}) async {
  //   /* move files to permanent storage */
  //
  //   //TODO check for storage space left.
  //
  //   var _baseName = pathFile.basename(path);
  //
  //   var appPath = await getExternalStorageDirectory();
  //   if (!Directory("${appPath!.path}/$platform").existsSync()) {
  //     //create the directory if it dosen't exist yet
  //     Directory("${appPath.path}/$platform")
  //         .createSync(recursive: true);
  //   }
  //   File _file = File(path);
  //   await _file.copy("${appPath.path}/$platform/$_baseName"); //copy the file to the new directory
  // }

  static Future<bool> checkFileDownloaded({
    required String platform,
    required String path,
  }) async {
    // check if a file has already been downloaded
    // String _result = "";
    // var _baseName = pathFile.basename(path);

    // switch (platform) {
    //    case "Whatsapp":
    //      _result = "/storage/emulated/0/Download/saveit/$platform/$_baseName";
    //      break;
    //    case "businesswhatsapp":
    //      _result = "/storage/emulated/0/saveit/businesswhatsapp/";
    //      break;
    //    case "gbwhatsapp":
    //      _result = "/storage/emulated/0/saveit/gbwhatsapp/";
    //      break;
    //    case "instagram":
    //      _result = "/storage/emulated/0/saveit/whatsapp/";
    //      break;
    //    default:
    //      _result = "/storage/emulated/0/saveit/whatsapp/";
    //  }
    // }
    // }

    if (File("/storage/emulated/0/Download/saveit/$platform/" +
            pathFile.basename(path))
        .existsSync()) {
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
