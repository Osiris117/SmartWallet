import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';

class CongratsPage extends StatefulWidget {
  const CongratsPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(builder: (_) => const CongratsPage());

  @override
  State<CongratsPage> createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Congrat.mp4')
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logof.png', height: 48),
              const SizedBox(height: 18),
              Text('¡Muchas felicitaciones!', style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tu cuenta ha sido verificada con éxito. ¡Estás listo/a para empezar a usar WalkYou!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),

              // Video area
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Color.fromRGBO(0,0,0,0.04), blurRadius: 12, offset: const Offset(0, 8))],
                ),
                child: Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
                      : const CircularProgressIndicator(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ir al inicio: reemplaza la pila por HomeScreen
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ir al inicio', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
