import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      title: 'Deopay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const HomeScreen(),
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
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,2))
          ]),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset('assets/images/character.svg', fit: BoxFit.contain),
          ),
        )
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
