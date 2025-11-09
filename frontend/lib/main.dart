import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import 'voice_continue_page.dart';

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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Intro.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome(String mode) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
                    Image.asset('assets/images/Logo.png', height: 48),
                    const SizedBox(width: 10),
                    Text(
                      'WalkYou',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2B6EDC), // azul parecido al mockup
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
                  child: _controller.value.isInitialized
                      ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
                      : Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.push(context, VoiceContinuePage.route()),
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
                onPressed: () => _goToHome('signs'),
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
    // Creates a rounded top area with a card overlapping
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0,8))],
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
        )
      ],
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.send, 'label': 'Pay'},
      {'icon': Icons.request_page, 'label': 'Request'},
      {'icon': Icons.add, 'label': 'Add Money'},
      {'icon': Icons.book, 'label': 'Passbook'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((it) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E9E7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(it['icon'] as IconData, color: const Color(0xFF7A5444)),
              ),
              const SizedBox(height: 8),
              Text(it['label'] as String, style: const TextStyle(fontSize: 12))
            ],
          );
        }).toList(),
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
          Container(width: 72, height: 72, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.wallet, color: Colors.white))
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
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
