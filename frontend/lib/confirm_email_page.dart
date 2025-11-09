import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(builder: (_) => const ConfirmEmailPage());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset('assets/images/Logo.png', height: 48, errorBuilder: (c, e, s) => const SizedBox.shrink()),
                const SizedBox(height: 18),

                // Decorative illustration (reuse voice_page.png if present)
                Center(
                  child: Container(
                    width: 260,
                    height: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Image.asset('assets/images/voice_page.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.mark_email_read, size: 96, color: Colors.blueAccent)),
                  ),
                ),

                const SizedBox(height: 18),

                Text('¡Un paso más!', style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Verifica tu correo electrónico', style: theme.textTheme.titleMedium?.copyWith(color: Colors.black87)),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Para activar tu cuenta, revisa el correo que te enviamos y haz clic en el enlace de verificación.',
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 18),

                ElevatedButton(
                  onPressed: () {
                    // Open mail app is platform-specific; for now, just pop or simulate
                    // Leave placeholder for integration with url_launcher if desired.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ir a mi Correo', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),

                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87),
                    children: [
                      const TextSpan(text: '¿No lo recibiste? '),
                      TextSpan(
                        text: 'Reenviar correo',
                        style: const TextStyle(color: Color(0xFF2B6EDC)),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correo reenviado (simulado)')));
                        },
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
