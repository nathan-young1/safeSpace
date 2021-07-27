import 'dart:io';
import 'package:file_picker/file_picker.dart';

String? fileUrl;
File? putFile;
List<File> downloadFiles = [];
int documentNo = 0;
Future<List<File>> filePicker() async {
          List<File> files = [];
          FilePickerResult? picked = await FilePicker.platform.pickFiles(allowMultiple: true);
          if(picked != null) {
            files = picked.paths.map((path) => File(path!)).toList();
          }
          return files;
          }