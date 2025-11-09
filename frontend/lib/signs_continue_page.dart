import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'voice_continue_page.dart';

class SignsContinuePage extends StatefulWidget {
  const SignsContinuePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const SignsContinuePage());

  @override
  State<SignsContinuePage> createState() => _SignsContinuePageState();
}

class _SignsContinuePageState extends State<SignsContinuePage> {
  late VideoPlayerController _controller;
  bool _isVideoComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Senas.mp4')
      ..initialize().then((_) {
        if (mounted) {
          _controller.setLooping(false);
          _controller.play();
          setState(() {});
          
          _controller.addListener(_videoListener);
        }
      }).catchError((error) {
        print('Error loading video: $error');
        _navigateToNext();
      });
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration && 
        !_isVideoComplete && 
        _controller.value.duration.inMilliseconds > 0) {
      _isVideoComplete = true;
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const VoiceContinuePage()),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lenguaje de Señas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: _controller.value.isInitialized
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'play',
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'skip',
                  onPressed: _navigateToNext,
                  child: const Icon(Icons.skip_next),
                ),
              ],
            )
          : null,
    );
  }
}
