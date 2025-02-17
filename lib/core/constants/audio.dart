// import 'package:flutter/material.dart';
// import 'package:voice_message_package/voice_message_package.dart';
// import '../../../core/theme/pallete.dart';
//
// class AudioWaveformWidget extends StatefulWidget {
//   final String audioUrl;
//   final int maxDuration;
//   final int index;
//   final List<VoiceController> controllers;
//
//   AudioWaveformWidget({
//     Key? key,
//     required this.audioUrl,
//     required this.maxDuration,
//     required this.index,
//     required this.controllers,
//   }) : super(key: key);
//
//   @override
//   _AudioWaveformWidgetState createState() => _AudioWaveformWidgetState();
// }
//
// class _AudioWaveformWidgetState extends State<AudioWaveformWidget> {
//   static int? currentlyPlayingIndex; // Tracks the currently playing audio
//
//   @override
//   void dispose() {
//     // Ensure the controller for this widget is disposed when the widget is disposed
//     widget.controllers[widget.index].stopPlaying(); // Stop playing audio when disposed
//     widget.controllers[widget.index].dispose(); // Dispose the controller to free resources
//     super.dispose();
//   }
//
//   void playPauseAudio() {
//     final currentController = widget.controllers[widget.index];
//
//     if (currentlyPlayingIndex == widget.index) {
//       // If the same widget is already playing, toggle play/pause
//       if (currentController.isPlaying) {
//         currentController.pausePlaying(); // Pause audio
//       } else {
//         currentController.play(); // Play audio
//       }
//     } else {
//       // If a different widget was playing, stop the current audio and start the new one
//       if (currentlyPlayingIndex != null) {
//         widget.controllers[currentlyPlayingIndex!].stopPlaying(); // Stop previously playing audio
//       }
//
//       // Update the playing index and play the current audio
//       setState(() {
//         currentlyPlayingIndex = widget.index;
//       });
//       currentController.play(); // Start playing the new audio
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.audioUrl.isEmpty
//         ? const SizedBox()
//         : VoiceMessageView(
//       controller: widget.controllers[widget.index],
//       circlesColor: Palette.primaryColor,
//       playIcon: IconButton(
//         icon: Icon(Icons.play_arrow, color: Palette.whiteColor),
//         onPressed: playPauseAudio,
//       ),
//       pauseIcon: IconButton(
//         icon: Icon(Icons.pause, color: Palette.whiteColor),
//         onPressed: playPauseAudio,
//       ),
//       activeSliderColor: Palette.primaryColor,
//       playPauseButtonLoadingColor: Palette.whiteColor,
//       innerPadding: 12,
//       cornerRadius: 20,
//     );
//   }
// }
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayan/core/constants/variables.dart';
import '../theme/pallete.dart';
import '../utils/utils.dart';

final audioManagerProvider = ChangeNotifierProvider((ref) => AudioManager());

class AudioManager extends ChangeNotifier {
  AudioPlayer? _currentPlayer;
  String? _currentPlayingUrl;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  String? get currentPlayingUrl => _currentPlayingUrl;

  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _isPlaying;

  //Play audio
  Future<void> play(String url) async {
    if (_currentPlayingUrl != url) {
      await _stopCurrentAudio();
      _currentPlayer = AudioPlayer();
      _currentPlayingUrl = url;

      _currentPlayer!.onPositionChanged.listen((Duration position) {
        _currentPosition = position;
        notifyListeners();
      });

      _currentPlayer!.onDurationChanged.listen((Duration duration) {
        _totalDuration = duration;
        notifyListeners();
      });

      _currentPlayer!.onPlayerComplete.listen((event) {
        _resetState();
      });

      await _currentPlayer!.play(UrlSource(url));
      _isPlaying = true;
      notifyListeners();
    } else {
      if (!_isPlaying) {
        await _currentPlayer!.resume();
        _isPlaying = true;
        notifyListeners();
      }
    }
  }

  // Pause audio
  Future<void> pause() async {
    if (_currentPlayer != null && _isPlaying) {
      await _currentPlayer!.pause();
      _isPlaying = false; // Update playing state to paused
      notifyListeners();
    }
  }

  // Stop and reset current audio
  Future<void> _stopCurrentAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      _resetState();
    }
  }

  // Seek to a specific position
  Future<void> seek(double value) async {
    if (_currentPlayer != null && _totalDuration > Duration.zero) {
      final newPosition =
      Duration(seconds: (value * _totalDuration.inSeconds).toInt());
      await _currentPlayer!.seek(newPosition);
    }
  }

  // Stop and reset current audio
  Future<void> stopCurrentAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      _resetState();
    }
  }

  // Reset audio state when audio is finished or stopped
  void _resetState() {
    _currentPlayingUrl = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    _isPlaying = false;
    notifyListeners();
  }
}

class VoicePlayer extends ConsumerStatefulWidget {
  // final ChatModel chatModel;
  final String url;
  final String duration;
  final bool inRecord;
  const VoicePlayer(
      {super.key,
        required this.url,
        required this.duration,
        required this.inRecord});

  @override
  VoicePlayerState createState() => VoicePlayerState();
}

class VoicePlayerState extends ConsumerState<VoicePlayer> {
  @override
  void deactivate() {
    if (mounted) {
      final audioManager = ref.read(audioManagerProvider);
      if (audioManager.currentPlayingUrl == widget.url) {
        audioManager.stopCurrentAudio(); // Stop and reset the current audio
      }
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final audioManager = ref.watch(audioManagerProvider);
    bool isPlaying =
        audioManager.currentPlayingUrl == widget.url && audioManager.isPlaying;

    // Calculate slider value (percentage of completion)
    double sliderValue =
    // widget.chatModel.senderId == 'Admin'
    //     ?
    (Duration(seconds: (int.tryParse(widget.duration.split(':').last) ?? 0))
        .inSeconds >
        0
        ? audioManager.currentPosition.inSeconds /
        Duration(
            seconds:
            (int.tryParse(widget.duration.split(':').last) ??
                0))
            .inSeconds
        : 0.0);
    // : (audioManager.totalDuration.inSeconds > 0
    //     ? audioManager.currentPosition.inSeconds /
    //         audioManager.totalDuration.inSeconds
    //     : 0.0);

    // Format duration (MM:SS)
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: h * 0.15,
        width: h * 0.7,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          // Background color of the message box
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: w * 0.03,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (!widget.inRecord) {
                        if (isPlaying) {
                          audioManager.pause();
                        } else {
                          audioManager.play(widget.url);
                        }
                      } else {
                        showSnackBar(
                            context, 'You are currently in record mode');
                      }
                    },
                    mouseCursor: SystemMouseCursors.click,
                    child: CircleAvatar(
                      backgroundColor: CupertinoColors.white,
                      child: Icon(
                        isPlaying
                            ? CupertinoIcons.pause_solid
                            : CupertinoIcons.play_arrow_solid,
                        color: CupertinoColors.activeGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: w * 0.6,
              child: Stack(
                children: [
                  // Text(''),
                  isPlaying
                      ? Slider(
                    value: sliderValue,
                    activeColor: Palette.primaryColor,
                    onChanged: (value) {
                      audioManager.seek(value);
                    },
                  )
                      : Slider(
                    value: 0.0,
                    activeColor: Palette.primaryColor,
                    onChanged: (value) {},
                  ),
                  // Positioned(
                  //   bottom: w * 0.005,
                  //   right: w * 0.003,
                  //   child: isPlaying
                  //       ? Text(
                  //     '${formatDuration(audioManager.currentPosition)}/${formatDuration(Duration(seconds: (int.tryParse(widget.duration.split(':').last) ?? 0)))}',
                  //     style: GoogleFonts.urbanist(
                  //       color: CupertinoColors.black,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: w * 0.008,
                  //     ),
                  //   )
                  //       : Text(
                  //     '00:00/${widget.duration}',
                  //     style: GoogleFonts.urbanist(
                  //       color: CupertinoColors.black,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: w * 0.008,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    /*return Column(
      children: [
        // Play/Pause Button
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              audioManager.pause();
            } else {
              audioManager.play(widget.chatModel.url);
            }
          },
        ),

        // Slider
        isPlaying ? Slider(
          value: sliderValue,
          onChanged: (value) {
            audioManager.seek(value);
          },
        ) : Slider(
          value: 0.0,
          onChanged: (value) {

          },
        ),

        // Current Position and Total Duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isPlaying ? Text('${formatDuration(audioManager.currentPosition)}/${formatDuration(audioManager.totalDuration)}') : Text('00:00/${widget.chatModel.duration}'),
            // Text(formatDuration(audioManager.totalDuration)),
          ],
        ),
      ],
    );*/
  }
}

