import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mayan/models/event_model.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

final eventRepositoryProvider = Provider((ref) {
  return EventRepository(firestore: ref.read(firestoreProvider));
});


class EventRepository{
  final FirebaseFirestore _firestore;
  EventRepository({
    required FirebaseFirestore firestore
  }):_firestore=firestore;

  CollectionReference get _event => _firestore.collection(FirebaseConstants.eventCollection);

  FutureEither addEvent( {required EventModel event}) async {
    log('555');
    try{
      final doc = _event.doc();
      event.id=doc.id;
      log('hereee');
      return right(
          doc.set(
              event.toJson()
          )
      );
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }

  }

  Stream<List<EventModel>> getEvent(){
    return _event.snapshots().map((event) => event.docs.map((e) => EventModel.fromJson(e.data() as Map<String,dynamic>)).toList());
  }

  Stream<EventModel> getEventById (String id){
    return _event.doc(id).snapshots().map((event) => EventModel.fromJson(event.data() as Map<String,dynamic>));
  }

  editEvent(EventModel event){
    try{
      _event.doc(event.id).update(event.toJson());
    }on  FirebaseException catch(e){
      print(e.toString());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> deleteEvent(String id) async {
    try {
      await _event.doc(id).delete();
      return right(unit); // Return success if deletion is successful
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? "Error deleting event"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }



}