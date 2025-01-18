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
