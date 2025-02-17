import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils/utils.dart';
import '../../../models/event_model.dart';
import '../repository/event_repository.dart';

final eventControllerProvider = NotifierProvider(() {
  return EventController();
});

final eventStreamProvider = StreamProvider<List<EventModel>>((
    ref) => ref.watch(eventControllerProvider.notifier).getEvent());

final getEventByIdProvider = StreamProvider.family<EventModel,String>((ref,id){
  return ref.watch(eventControllerProvider.notifier).getEventById(id);
});


class EventController extends Notifier{
  EventController();

  @override
  bool build(){
    return false;
  }

  addEvent(BuildContext context,EventModel event, File? ImgFiles) async {
    if(ImgFiles!=null){
      final res =await  ref.watch(storageRepositoryProvider).storeFile(
          path: 'event/${event.name}',
          id: event.name,
          file: ImgFiles
      );
      res.fold(
            (l)=> showSnackBar(context, l.message),
            (r)=> event=event.copyWith(images: [r]),
      );
    }

    final res = await ref.read(eventRepositoryProvider).addEvent(event: event);
    res.fold((l) {
      log(l.message);
    }, (r) {
      log('succcessss');
    });
  }

  Stream<List<EventModel>>getEvent(){
    return ref.watch(eventRepositoryProvider).getEvent();
  }

  getEventById(String id){
    return ref.read(eventRepositoryProvider).getEventById(id);
  }

  editEvent(BuildContext context,EventModel event, File? ImgFiles) async {
    if(ImgFiles!=null){
      final res =await  ref.watch(storageRepositoryProvider).storeFile(
          path: 'event/${event.name}',
          id: event.name,
          file: ImgFiles
      );
      res.fold(
            (l)=> showSnackBar(context, l.message),
            (r)=> event=event.copyWith(images: [r]),
      );
    }

    return ref.watch(eventRepositoryProvider).editEvent(event);
  }

  Future<void> deleteEvent(String id, BuildContext context) async {
    var res = await ref.read(eventRepositoryProvider).deleteEvent(id);
    res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, 'Event deleted successfully'),
    );
  }

}