import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

final firestoreProvider= Provider((ref) => FirebaseFirestore.instance);
final storageProvider= Provider((ref) => FirebaseStorage.instance);