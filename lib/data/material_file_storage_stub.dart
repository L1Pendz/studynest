import 'package:file_picker/file_picker.dart';

Future<String> storePickedMaterial(PlatformFile file, String id) {
  throw UnsupportedError('Saving selected documents is not supported here.');
}

Future<void> deleteStoredMaterial(String path) async {}

Future<void> clearStoredMaterials() async {}
