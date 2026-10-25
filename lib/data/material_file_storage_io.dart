import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> storePickedMaterial(PlatformFile file, String id) async {
  final documents = await getApplicationDocumentsDirectory();
  final directory = Directory(
    '${documents.path}${Platform.pathSeparator}study_materials',
  );
  await directory.create(recursive: true);

  final safeName = file.name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  final destination = File(
    '${directory.path}${Platform.pathSeparator}$id-$safeName',
  );

  if (file.path case final sourcePath?) {
    await File(sourcePath).copy(destination.path);
  } else {
    await destination.writeAsBytes(await file.readAsBytes());
  }

  return destination.path;
}

Future<void> deleteStoredMaterial(String path) async {
  final documents = await getApplicationDocumentsDirectory();
  final materialDirectory =
      '${documents.path}${Platform.pathSeparator}study_materials${Platform.pathSeparator}';
  if (!path.startsWith(materialDirectory)) return;

  final file = File(path);
  if (await file.exists()) await file.delete();
}
