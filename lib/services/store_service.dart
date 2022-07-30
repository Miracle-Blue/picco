import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'log_service.dart';

class StoreService {
  static var percentageStream = StreamController<double>();
  static final metadata = SettableMetadata(contentType: "image/jpeg");

  static final _storage = FirebaseStorage.instance;
  static const folderImage = "image";

  static Future<String?> uploadFile(File _image) async {
    final today =
        '${DateTime.now().month.toString()}-${DateTime.now().day.toString()}';
    final storageId = '$today-${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final storageReference =
          _storage.ref().child(folderImage).child(today).child(storageId);

      TaskSnapshot taskSnapshot =
          await storageReference.putFile(_image, metadata);

      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      Log.e(e.toString());
      return null;
    }
  }

  static Future<void> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (e) {
      Log.e("Error deleting db from cloud: $e");
    }
  }
}
