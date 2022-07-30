import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getDownloadsDirectory();
    return directory!.path;
  }

  Future<Uint8List> getImageFromNetwork(String url) async {
    final response = await get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> saveImage(String url) async {
    if (await Permissions.getDirectoryPermission()) {
      Log.i((await Permissions.getDirectoryPermission()).toString());

      final imageUint8List = await getImageFromNetwork(url);

      Log.i(imageUint8List.toString());
      Log.i(await _localPath);

      var path = '/storage/emulated/0/Download/images';
      await io.Directory(path).create(recursive: true);

      if (io.Directory(path).existsSync()) {
        io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
          ..create()
          ..writeAsBytesSync(imageUint8List);
      }
    }
  }

  void startDownLoad(BuildContext context, {required List<String> urls}) async {
    for (String url in urls) {
      double percent = 0;
      try {
        await Permissions.getDirectoryPermission();
        // Directory directory = await getTemporaryDirectory();
        // String path = "${directory.path}/${DateTime.now()}.jpg";
        String path = '/storage/emulated/0/Download/${DateTime.now()}.jpg';

        await Dio().download(url, path, onReceiveProgress: (rec, total) {
          percent = (rec / total) * 100;
          Log.d('$percent');
        });

        Utils.fireSnackBar(
          normalText: 'Image downloaded: $percent',
          redText: '',
          context: context,
        );
      } catch (e) {
        Log.w(e.toString());
      }
    }
  }
}
