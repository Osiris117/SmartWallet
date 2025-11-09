import 'package:flutter/material.dart';
import 'create_account_page.dart';
import 'main.dart';
import 'services/speech_service.dart';

class VoiceContinuePage extends StatefulWidget {
  const VoiceContinuePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const VoiceContinuePage());
  }

  @override
  State<VoiceContinuePage> createState() => _VoiceContinuePageState();
}

class _VoiceContinuePageState extends State<VoiceContinuePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SpeechService _speechService = SpeechService();
  bool _obscure = true;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speechService.initialize();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _speakPageContent();
  }

  Future<void> _speakPageContent() async {
    await _speechService.speak("Pantalla de inicio de sesión. Di iniciar sesión para continuar, o di crear cuenta para registrarte.");
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _startVoiceListening();
  }

  void _startVoiceListening() {
    if (!mounted) return;
    setState(() => _isListening = true);
    
    _speechService.startListening(
      onResult: (text) {
        String? command = _speechService.detectCommand(text);
        if (command == 'login') {
          _speechService.speak('Iniciando sesión');
          _login();
        } else if (command == 'register') {
          _speechService.speak('Abriendo registro');
          Navigator.of(context).push(CreateAccountPage.route());
        }
      },
      onComplete: () {
        if (mounted) setState(() => _isListening = false);
      },
    );
  }

  void _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Text('WalkYou',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        )),
                    const SizedBox(height: 6),
                    Text('Iniciar sesión / Registrarse',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(18),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('¡Hola de nuevo!',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      const SizedBox(height: 18),

                      if (true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: SizedBox(
                              height: 120,
                              child: Image.asset(
                                'assets/images/voice_page.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stack) {
                                  return const Icon(
                                    Icons.mic,
                                    size: 72,
                                    color: Colors.blueAccent,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

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
                              Text('Escuchando comandos...', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: 'Correo electrónico',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600]),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                          hintText: 'Contraseña',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 18),

                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Iniciar sesión'),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(context, CreateAccountPage.route());
                        },
                        icon: const Icon(Icons.handshake_outlined,
                            color: Colors.green),
                        label: const Text('Crear una cuenta',
                            style: TextStyle(color: Colors.green)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green.shade100),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
