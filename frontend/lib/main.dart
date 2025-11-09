import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'voice_continue_page.dart';
import 'signs_continue_page.dart';
import 'pages/home_options_page.dart';
import 'pages/send_money_page.dart';
import 'pages/receive_page.dart';
import 'services/speech_service.dart';

void main() {
  runApp(const DeopayApp());
}

class DeopayApp extends StatelessWidget {
  const DeopayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF0F7A66);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WalkYou',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController? _controller;
  final SpeechService _speechService = SpeechService();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speechService.initialize();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) _speakWelcomeMessage();
  }

  Future<void> _speakWelcomeMessage() async {
    await _speechService.speak("Bienvenido a Walk You. Selecciona tu modo de uso. Di voz o señas.");
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _startVoiceListening();
  }

  void _startVoiceListening() {
    if (!mounted) return;
    setState(() => _isListening = true);
    
    _speechService.startListening(
      onResult: (text) {
        _processVoiceCommand(text);
      },
      onComplete: () {
        if (mounted) {
          setState(() => _isListening = false);
        }
      },
    );
  }

  void _processVoiceCommand(String text) {
    String? command = _speechService.detectCommand(text);
    
    if (command == 'voice') {
      _speechService.speak('Modo de voz seleccionado');
      _goToVoiceMode();
    } else if (command == 'signs') {
      _speechService.speak('Modo de señas seleccionado');
      _goToSignsMode();
    }
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/Intro.mp4')
        ..initialize().then((_) {
          if (mounted) {
            _controller!.setLooping(true);
            _controller!.setVolume(0.0);
            _controller!.play();
            setState(() {});
          }
        });
    } catch (e) {
      print('Error loading video: $e');
    }
  }

  void _goToVoiceMode() {
    _speechService.stopListening();
    Navigator.push(context, VoiceContinuePage.route());
  }

  void _goToSignsMode() {
    _speechService.stopListening();
    Navigator.push(context, SignsContinuePage.route());
  }

  @override
  void dispose() {
    _controller?.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/Logof.png', height: 48, errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet, size: 48)),
                    const SizedBox(width: 10),
                    Text(
                      'WalkYou',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2B6EDC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('¡Bienvenido a WalkYou!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tu billetera digital, accesible para todos.', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              
              Expanded(
                child: Center(
                  child: _controller != null && _controller!.value.isInitialized
                      ? AspectRatio(aspectRatio: _controller!.value.aspectRatio, child: VideoPlayer(_controller!))
                      : Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: const Center(child: Icon(Icons.account_balance_wallet, size: 80, color: Colors.grey)),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),

              if (_isListening)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.mic, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('Escuchando...', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _goToVoiceMode,
                icon: const Icon(Icons.mic, color: Colors.white),
                label: const Text('Continuar con Voz', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ADE80),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _goToSignsMode,
                icon: const Icon(Icons.pan_tool, color: Colors.white),
                label: const Text('Continuar con Señas', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            children: [
              _TopHeader(),
              const SizedBox(height: 12),
              _StackedCard(),
              const SizedBox(height: 16),
              _ActionButtonsRow(),
              const SizedBox(height: 16),
              _PromoCard(),
              const Spacer(),
              const SizedBox(height: 8),
              _BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Hello Satwik,', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text('What would you like to do today ?', style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/Logo.png'),
        ),
      ],
    );
  }
}

class _StackedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF0F7A66),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('DEOPAY', style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700)),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: -36,
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Wallet Balance', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 6),
                      Text('\$2100', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: 72, height: 72, child: SvgPicture.asset('assets/images/coin.svg'))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionButton(
            icon: Icons.send,
            label: 'Pay',
            onTap: () => Navigator.push(context, SendMoneyPage.route()),
          ),
          _ActionButton(
            icon: Icons.request_page,
            label: 'Request',
            onTap: () => Navigator.push(context, ReceivePage.route()),
          ),
          _ActionButton(
            icon: Icons.add,
            label: 'Add Money',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función en desarrollo')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.book,
            label: 'Passbook',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función en desarrollo')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4E9E7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: const Color(0xFF7A5444)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF185D57),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Introducing Virtual Banking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Start your Digital Savings Account today!', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.wallet, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _NavItem(icon: Icons.home, label: 'Home', active: true),
          _NavItem(icon: Icons.list, label: 'Orders'),
          _NavItem(icon: Icons.chat, label: 'Chat'),
          _NavItem(icon: Icons.mail, label: 'Inbox'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = active ? Theme.of(context).colorScheme.primary : Colors.black54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color))
      ],
    );
  }
}
