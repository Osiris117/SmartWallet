import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SignsContinuePage extends StatefulWidget {
  const SignsContinuePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(builder: (_) => const SignsContinuePage());

  @override
  State<SignsContinuePage> createState() => _SignsContinuePageState();
}

class _SignsContinuePageState extends State<SignsContinuePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Senas.mp4')
      ..initialize().then((_) {
        _controller.setLooping(false);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Señas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
              : const CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: _controller.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            )
          : null,
    );
  }
}
