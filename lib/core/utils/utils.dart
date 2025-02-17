import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
        SnackBar(
            content:Text(message.toString(),style: const TextStyle(color: Colors.white),)
        )
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  if(image!=null){
    return image;
  }
}

Future<FilePickerResult?> pickVideo() async {
  final video = await FilePicker.platform.pickFiles(type: FileType.video);
  if(video!=null){
    return video;
  }
}

Future<bool> alert(BuildContext context, String message,) async {
  bool result=  await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0)
        ),
        title: const Text('Are you sure ?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop(false);
            },
            child: const Text(
                'No',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                )
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context, rootNavigator: true).pop(true);
            },
            child: const Text(
                'Yes',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                )
            ),
          )
        ],
      )
  );
  return result;
}