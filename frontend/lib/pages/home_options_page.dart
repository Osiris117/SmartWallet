import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/receive_page.dart';
import 'package:smart_wallet/services/speech_service.dart';
import 'send_money_page.dart';

class HomeOptionsPage extends StatefulWidget {
  const HomeOptionsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeOptionsPage());
  }

  @override
  State<HomeOptionsPage> createState() => _HomeOptionsPageState();
}

class _HomeOptionsPageState extends State<HomeOptionsPage> {
  final SpeechService _speechService = SpeechService();
  String _lastCommand = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    await _speechService.initialize();
  }

  void _startListening() {
    setState(() => _isListening = true);
    _speechService.startListening(
      onResult: (text) {
        setState(() => _lastCommand = text);
        _processCommand(text);
      },
      onComplete: () {
        setState(() => _isListening = false);
      },
    );
  }

  void _processCommand(String command) {
    void showInfo(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (command == 'COMMAND_PAY') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SendMoneyPage()));
    } else if (command == 'COMMAND_RECEIVE') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceivePage()));
    } else if (command == 'COMMAND_HELP') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Comandos de Voz Disponibles'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('• "Pagar" o "Enviar dinero" - Ir a la pantalla de pagos'),
                Text('• "Recibir" o "Cobrar" - Ir a la pantalla de cobros'),
                Text('• "Historial" - Ver transacciones'),
                Text('• "Mi saldo" - Consultar balance'),
                Text('• "Configuración" - Abrir ajustes'),
                Text('• "Perfil" - Ver mi cuenta'),
                Text('• "Cerrar sesión" - Bloquear la app'),
                Text('• "Enviar X pesos" - Iniciar transferencia'),
                Text('• "Ayuda" - Ver este mensaje'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } else if (command == 'COMMAND_BALANCE') {
      showInfo('Tu saldo actual es: \$1,234.56');
    } else if (command == 'COMMAND_SETTINGS') {
      showInfo('Abriendo configuración...');
    } else if (command == 'COMMAND_PROFILE') {
      showInfo('Abriendo perfil...');
    } else if (command == 'COMMAND_LOCK') {
      showInfo('Cerrando sesión...');
    } else if (command == 'COMMAND_NOTIFICATIONS') {
      showInfo('Abriendo notificaciones...');
    } else if (command.startsWith('COMMAND_AMOUNT_')) {
      final amount = command.replaceAll('COMMAND_AMOUNT_', '');
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => SendMoneyPage(initialAmount: double.parse(amount))
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/Logof.png', height: 32),
                      const SizedBox(width: 8),
                      const Text(
                        'WalkYou',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B6EDC),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        onPressed: _startListening,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'What will we do today?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2B6B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _OptionCard(
                              title: 'Enviar',
                              icon: 'assets/images/Enviar.png',
                              color: const Color(0xFFE8F1FF),
                              borderColor: const Color(0xFF93C0FF),
                              onTap: () {
                                Navigator.of(context).push(SendMoneyPage.route());
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _OptionCard(
                              title: 'Recibir',
                              icon: 'assets/images/Recibir.png',
                              color: const Color(0xFFE7FFF3),
                              borderColor: const Color(0xFF93FFBE),
                              onTap: () {
                                Navigator.of(context).push(ReceivePage.route());
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 80, errorBuilder: (c, e, s) {
              return Icon(
                title == 'Enviar' ? Icons.send_rounded : Icons.download_rounded,
                size: 48,
                color: borderColor,
              );
            }),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Inicio', isSelected: currentIndex == 0),
      _NavItem(icon: Icons.access_time, label: 'Actividad', isSelected: currentIndex == 1),
      _NavItem(icon: Icons.person_outline, label: 'Perfil', isSelected: currentIndex == 2),
      _NavItem(icon: Icons.settings_outlined, label: 'Configuración', isSelected: currentIndex == 3),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? const Color(0xFF2B6EDC) : Colors.grey;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
