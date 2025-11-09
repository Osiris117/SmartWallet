import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const DeopayApp());
}

class DeopayApp extends StatelessWidget {
  const DeopayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deopay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F7A66)),
        useMaterial3: true,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hello Satwik,', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 20),
              _BalanceCard(),
              const SizedBox(height: 16),
              _ActionButtonsRow(),
              const SizedBox(height: 16),
              _PromoCard(),
              const Spacer(),
              _BottomNav()
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF185D57),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Wallet balance', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text('\$2100', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((it) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(it['icon'] as IconData, color: Colors.brown),
            ),
            const SizedBox(height: 8),
            Text(it['label'] as String, style: const TextStyle(fontSize: 12))
          ],
        );
      }).toList(),
    );
  }
}

class _PromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Introducing Virtual Banking', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Start your Digital Savings Account today!', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 72, height: 72, decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(12))),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _NavItem(icon: Icons.home, label: 'Home', active: true),
        _NavItem(icon: Icons.list, label: 'Orders'),
        _NavItem(icon: Icons.chat, label: 'Chat'),
        _NavItem(icon: Icons.mail, label: 'Inbox'),
      ],
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Theme.of(context).colorScheme.primary : Colors.black54),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: active ? Theme.of(context).colorScheme.primary : Colors.black54))
      ],
    );
  }
}
