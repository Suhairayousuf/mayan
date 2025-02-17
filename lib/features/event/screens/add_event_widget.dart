import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayan/core/constants/constants.dart';
import 'package:mayan/core/pallette/pallete.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../core/constants/audio.dart';
import '../../../core/constants/variables.dart';
import '../../../core/theme/pallete.dart';
import '../../../core/utils/utils.dart';


class AddEventWidget extends ConsumerStatefulWidget {
  const AddEventWidget({super.key});

  @override
  ConsumerState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends ConsumerState<AddEventWidget> {

  TextEditingController _dateController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  bool isSwitched=false;

  File? selectedImgFile;
  List imgFiles=[];
  selectImage() async {
    final res= await pickImage();
    if(res!=null){
      setState(() {
        selectedImgFile = File(res.files.first.path!);
        imgFiles.add(selectedImgFile);
      });
    }

  }

  File? selectedVideoFile;
  List videoFiles=[];
  selectVideo() async {
    final res= await pickVideo();
    if(res!=null){
      setState(() {
        selectedVideoFile = File(res.files.first.path!);
        videoFiles.add(selectedVideoFile);
      });
    }

  }

  Future<void> _initialize() async {
    appDirectory = await getApplicationDocumentsDirectory();
    setState(() {});
  }

  Future<String> _getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recorded_audio.wav';
  }
  void _startTimer(WidgetRef ref) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(recordDurationProvider.notifier).update((state) => state + 1);
    });
  }
  Future<void> _startRecording() async {

    if (await _audioRecorder.hasPermission()) {
      final path = await _getPath();
      print("path1111111111");
      print(path);
      print("path1111111111");
      await _audioRecorder.start(RecordConfig(
          encoder: AudioEncoder.wav

      ),path: path,);
      // await _audioRecorder.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));

      print("path222222222");
      print(path);
      print("path222222222");
      ref.watch(isRecordingProvider.notifier).update((state) => true);
      ref.watch(recordDurationProvider.notifier).update((state) => 0);
      _startTimer(ref);
    }
  }

  String formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> stopRecording(WidgetRef ref) async {
    _timer?.cancel();

    final recordDuration = ref.read(recordDurationProvider);


    String formattedDuration = formatDuration(recordDuration);

    if (recordDuration < 1) {
      ref.read(isRecordingProvider.notifier).update((state) => false);
      ref.read(recordDurationProvider.notifier).update((state) => 0);
      return;
    }

    String? recordedPath = await _audioRecorder.stop();
    if (recordedPath != null) {
      final file = File(recordedPath);
      if (await file.length() == 0) {
        ref.read(isRecordingProvider.notifier).update((state) => false);
        ref.read(recordDurationProvider.notifier).update((state) => 0);
        return;
      }

      ref.read(pathProvider.notifier).update((state) => recordedPath);
      ref.read(recordDurationProvider.notifier).update((state) => 0);

      final bytes = await file.readAsBytes();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('audio/${DateTime.now().millisecondsSinceEpoch}.m4a');

      ref.read(isUploadingProvider.notifier).update((state) => true);

      await storageRef.putData(
        bytes,
        SettableMetadata(contentType: 'audio/aac'),
      ).then((_) async {
        String audioUrl = await storageRef.getDownloadURL();

        ref.watch(audioUrlsProvider.notifier).update((state) {
          return List.from(state)
            ..add({
              'url': audioUrl,
              'duration': formattedDuration,
            });
        });
      });

      ref.read(isUploadingProvider.notifier).update((state) => false);
    }

    ref.read(isRecordingProvider.notifier).update((state) => false);
  }

  Widget _buildTimer(WidgetRef ref) {
    final recordDuration = ref.watch(recordDurationProvider);
    final isRecording = ref.watch(isRecordingProvider);
    final isUploading = ref.watch(isUploadingProvider);

    if (isUploading) {
      return Container(
        height: h * .065,
        width: w * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            'Audio Uploading...',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: w * 0.03,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (!isRecording) {
      return Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: () async {
          _startRecording();
        },
        child: Container(
          height: h * .065,
          width: w * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Palette.primaryColor,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Recording',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: w * 0.03,
                    color: Colors.white,
                  ),
                ),
                const Icon(Icons.keyboard_voice, color: Colors.white),
              ],
            ),
          ),
        ),
      );
    }
    String _formatNumber(int number) {
      return number < 10 ? '0$number' : '$number';
    }
    final minutes = _formatNumber(recordDuration ~/ 60);
    final seconds = _formatNumber(recordDuration % 60);

    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () async {
        stopRecording(ref);
      },
      child: Container(
        height: h * .065,
        width: w * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.red,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$minutes:$seconds',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: w * 0.03,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.stop_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioList() {
    return  Center(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: ref.watch(audioUrlsProvider).length,
          itemBuilder: (context, index) {
            // String urlData =ref.watch(audioUrlsProvider)[index];
            print( ref.watch(audioUrlsProvider));
            print(
                "listtttttttttttttttttttttttttttttttttttttttttttttttttttt");
            final audioItem =ref.watch(audioUrlsProvider)[index];
            final audioUrl = audioItem['url'];
            final duration = audioItem['duration'];
            return Padding(
              padding:  EdgeInsets.only(left: w*0.05,bottom: w*0.05),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        width: w * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade200,
                          borderRadius:
                          BorderRadius.circular(
                              10),
                        ),
                        child: VoicePlayer(
                          url: audioUrl,
                          duration: duration.toString(),

                          key: UniqueKey(),
                          inRecord: ref.watch(onRecord),
                        )

                      // AudioPlayer(
                      //   source: ap.AudioSource.uri(
                      //       Uri.tryParse(
                      //           _audioUrl[index])!),
                      //   onDelete: () {},
                      //   message: true,
                      //   time: '',
                      // ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              AlertDialog(
                                title: const Text(
                                    "Delete Audio"),
                                content: const Text(
                                    'Do You Want To Delete This Audio'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx)
                                          .pop();
                                    },
                                    child: const Text(
                                        "No"),
                                  ),
                                  TextButton(
                                    onPressed: () {

                                      final currentList = ref.read(audioUrlsProvider.notifier).state;
                                      ref.read(audioUrlsProvider.notifier).state = currentList.where((url) => url != audioItem).toList();
                                      // ref.watch(audioUrlsProvider.notifier).update((state) {
                                      //   return state..removeAt(index);
                                      // });

                                      Navigator.of(ctx)
                                          .pop();
                                    },
                                    child: const Text(
                                        "Yes"),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            );
          }),
    );
    // return ListView.builder(
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemCount: ref.watch(audioUrlsProvider).length,
    //   itemBuilder: (context, index) {
    //     final audioData = ref.watch(audioUrlsProvider)[index];
    //     final dynamic durationData = audioData['duration']; // Dynamic to handle both String and int
    //     int audioDuration = 0;
    //
    //
    //     if (durationData is String) {
    //       final parts = durationData.split(':');
    //       audioDuration =
    //           (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
    //     } else if (durationData is int) {
    //       audioDuration = durationData;
    //     } else {
    //       throw Exception("Invalid format for audio duration");
    //     }
    //
    //     final String urlData = audioData['url'];
    //     // int recordDuration = ref.watch(recordDurationProvider);
    //     // final audioData = ref.watch(audioUrlsProvider)[index];
    //     // final String urlData = audioData['url'];
    //     double screenWidth = w * 1.3;
    //
    //     int noiseCount = (screenWidth / 10).toInt();
    //
    //     var audios=ref.watch(audioUrlsProvider);
    //
    //     return Padding(
    //         padding: EdgeInsets.only(left: w*0.075,right: w*0.075,top: 10),
    //         child: Container(
    //           height: w * 0.14,
    //           decoration: BoxDecoration(
    //               color: Palette.whiteColor,
    //               borderRadius: BorderRadius.circular(w * 0.06)),
    //           child: Row(
    //             children: [
    //               ref.watch(audioUrlsProvider)[index].isNotEmpty?SizedBox(
    //                 // width: w*0.8,
    //                 child:   ListView.builder(
    //                     shrinkWrap: true,
    //                     scrollDirection: Axis.vertical,
    //                     itemCount: ref.watch(audioUrlsProvider).length,
    //                     itemBuilder: (context, index) {
    //                       print( ref.watch(audioUrlsProvider));
    //                       print(
    //                           "listtttttttttttttttttttttttttttttttttttttttttttttttttttt");
    //                       final audioItem =ref.watch(audioUrlsProvider)[index];
    //                       final audioUrl = audioItem['url'];
    //                       final duration = audioItem['duration'];
    //                       return Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Row(
    //                           mainAxisAlignment:
    //                           MainAxisAlignment.center,
    //                           crossAxisAlignment:
    //                           CrossAxisAlignment.center,
    //                           children: [
    //                             Container(
    //                                 width: w * 0.24,
    //                                 height: 60,
    //                                 decoration: BoxDecoration(
    //                                   // color: Colors.grey.shade200,
    //                                   borderRadius:
    //                                   BorderRadius.circular(
    //                                       10),
    //                                 ),
    //                                 child: VoicePlayer(
    //                                   url: audioUrl,
    //                                   duration: duration,
    //
    //                                   key: UniqueKey(),
    //                                   inRecord: ref.watch(onRecord),
    //                                 )
    //
    //                               // AudioPlayer(
    //                               //   source: ap.AudioSource.uri(
    //                               //       Uri.tryParse(
    //                               //           _audioUrl[index])!),
    //                               //   onDelete: () {},
    //                               //   message: true,
    //                               //   time: '',
    //                               // ),
    //                             ),
    //                             IconButton(
    //                                 onPressed: () {
    //                                   showDialog(
    //                                     context: context,
    //                                     builder: (ctx) =>
    //                                         AlertDialog(
    //                                           title: const Text(
    //                                               "Delete Audio"),
    //                                           content: const Text(
    //                                               'Do You Want To Delete This Audio'),
    //                                           actions: <Widget>[
    //                                             TextButton(
    //                                               onPressed: () {
    //                                                 Navigator.of(ctx)
    //                                                     .pop();
    //                                               },
    //                                               child: const Text(
    //                                                   "No"),
    //                                             ),
    //                                             TextButton(
    //                                               onPressed: () {
    //
    //
    //                                                 // _audioUrl.remove(
    //                                                 //     _audioUrl[index]);
    //                                                 // savedVoice.remove(savedVoice[index]);
    //                                                 setState(() {});
    //
    //                                                 Navigator.of(ctx)
    //                                                     .pop();
    //                                               },
    //                                               child: const Text(
    //                                                   "Yes"),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                   );
    //                                 },
    //                                 icon: Icon(Icons.delete)),
    //                           ],
    //                         ),
    //                       );
    //                     }),
    //               ):Loader(),
    //
    //             ],
    //           ),
    //         ));
    //   },
    // );
  }

  final isRecordingProvider = StateProvider((ref) => false);
  final isLoadingProvider = StateProvider((ref) => true);
  final recordDurationProvider = StateProvider<int>((ref) => 0);
  final pathProvider = StateProvider<String?>((ref) => "");
  final isUploadingProvider = StateProvider<bool>((ref) => false);
  final isLoading = StateProvider(
        (ref) => false,
  );
  final audioUrlsProvider = StateProvider<List<Map<String, dynamic>>>((ref) {
    return [];
  });
  final onRecord = StateProvider(
        (ref) => false,
  );

  late Directory appDirectory;
  final AudioRecorder _audioRecorder=AudioRecorder();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Event',
          style: GoogleFonts.poppins(color: Colors.black,fontSize: 20 ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name Input
            Card(
              child: TextField(
                autocorrect: false, // Prevents automatic underlining
                enableSuggestions: false,

                style: GoogleFonts.poppins(color: Colors.grey), // Text color and font
                decoration: InputDecoration(

                  focusedBorder: InputBorder.none,

                  labelText: 'Event name*',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey), // Label text color
                  filled: true,
                  fillColor: Colors.white, // Background color (change if needed)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,

                  ),
                ),
              ),
            )
            ,
            SizedBox(height: 16),

            // Notes Input
            Card(

              child: TextField(
                decoration: InputDecoration(

                  // border: InputBorder.none, // Removes underline and border
                  focusedBorder: InputBorder.none,

                  labelText: 'Type the note here...',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,

                  ),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 16),

            // Date Picker Input
            Card(
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  // Removes underline when inactive
                  focusedBorder: InputBorder.none,
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Date',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Location Input
            Card(
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  labelStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Add location',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Add Image, Video, and Recording Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add Image Button
                GestureDetector(
                  onTap: selectImage,
                  child: Column(
                    children: [
                      Card(
                        child: Container(

                          height: w*0.27,
                          width: w*0.27,
                          decoration: BoxDecoration(

                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              //Icon(Icons.image, color: Colors.blue),
                              Image.asset('assets/images/imagepicker.png', ),
                              Text(
                                'Add image',
                                style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                    ],
                  ),
                ),

                // Add Video Button
                GestureDetector(
                  onTap: selectVideo,
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          height: w*0.27,
                          width: w*0.27,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [

                              Image.asset('assets/images/video.png',height: 25,width: 25,color: Colors.grey, ),

                              Text(
                                'Add video',
                                style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                    ],
                  ),
                ),

                // Add Recording Button
                Column(
                  children: [
                    Card(
                      child: Container(
                        height: w*0.27,
                        width: w*0.27,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.keyboard_voice_outlined, color: Colors.grey,size: 35,),
                            Text(
                              'Add recording',
                              style: GoogleFonts.poppins(color: Colors.grey,fontSize: w*0.032),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                  ],
                ),
              ],
            ),

            imgFiles.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Images',
                            style: GoogleFonts.poppins(
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(imgFiles.length, (index){
                          return  Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration:BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(imgFiles[index]!,),
                                  )
                              ),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                      onTap: () async {
                                        bool pressed= await alert(context, 'Remove image?');
                                        if(pressed){
                                          imgFiles.removeAt(index);
                                          setState(() {

                                          });
                                        }
                                      },
                                      child: const Icon(Icons.delete,color: Colors.red,size: 15,)
                                  )
                              ),
                            ),
                          );
                          //     :  Padding(
                          //   padding: const EdgeInsets.all(5.0),
                          //   child: CircleAvatar(
                          //     radius: 32,
                          //     child: GestureDetector(
                          //         onTap: ()=>selectImage(),
                          //         child: const Icon(Icons.image)
                          //     ),
                          //   ),
                          // );
                        }),
                      ),

                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 60,
                      //       width: 120,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey[200],
                      //         borderRadius: BorderRadius.circular(8),
                      //         // image: DecorationImage(
                      //         //   image: AssetImage(assetPath),
                      //         //   fit: BoxFit.cover,
                      //         // ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            )
                : Container(),

            videoFiles.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Videos',
                            style: GoogleFonts.poppins(
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: List.generate(videoFiles.length, (index){
                          return  Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration:BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: AssetImage(Constants.video)
                                    // FileImage(videoFiles[index]!,),
                                  )
                              ),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                      onTap: () async {
                                        bool pressed= await alert(context, 'Remove video?');
                                        if(pressed){
                                          videoFiles.removeAt(index);
                                          setState(() {

                                          });
                                        }
                                      },
                                      child: const Icon(Icons.delete,color: Colors.red,size: 15,)
                                  )
                              ),
                            ),
                          );
                        }),
                      ),

                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 60,
                      //       width: 120,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey[200],
                      //         borderRadius: BorderRadius.circular(8),
                      //         // image: DecorationImage(
                      //         //   image: AssetImage(assetPath),
                      //         //   fit: BoxFit.cover,
                      //         // ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            )
                : Container(),


            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(left: w*0.075,right: w*0.075,),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w*0.03),
                    color: Palette.whiteColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                    dashPattern: const [8],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(w * 0.03),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(w * 0.03)),
                      child: SizedBox(
                        // height: h * 0.2,
                        width: w * 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: w * 0.08,
                                // height: h * 0.07,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: SvgPicture.asset(Constants.podcast)),
                            SizedBox(height: h * 0.01),
                            Text(
                              ref.watch(isRecordingProvider)
                                  ? "Recording..."
                                  : "Upload Audio",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontWeight: FontWeight.w600)
                              ),
                            ),
                            SizedBox(height: h * 0.01),

                            _buildTimer(ref),
                            SizedBox(height: h * 0.01),
                            //   _buildRecordStopControl(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            ref.watch(audioUrlsProvider).isEmpty
                ? SizedBox()
                : Center(
              child: Container(
                // height: h * 0.18,

                child: _buildAudioList(),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            // SizedBox(height: 16),


            // Show selected image preview (if any)
            // if (_selectedImage != null) ...[
            //   SizedBox(height: 16),
            //   Text('Selected Image:'),
            //   SizedBox(height: 8),
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(12),
            //     child: Image.file(
            //       _selectedImage!,
            //       height: 150,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ],
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Icon(Icons.add, color: primaryColor),
                Text(
                  'Add new',
                  style: GoogleFonts.poppins(color: primaryColor,fontSize: w*0.032),
                )
              ],
            ),
            // Reminder Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminds me', style: GoogleFonts.poppins(color: Colors.black),
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  thumbColor: WidgetStateProperty.all(Colors.white), // White button (thumb)
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return primaryColor; // Change this to your primary color
                    }
                    return Colors.grey.shade300; // Transparent track when inactive
                  }),
                  trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return primaryColor; // Primary color outline when active
                    }
                    return Colors.white; // White outline when inactive
                  }),
                )

              ],
            ),
            SizedBox(height: 16),
            // Create Event Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle create event logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: Text('Create Event', style: GoogleFonts.poppins(fontSize: 16,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
