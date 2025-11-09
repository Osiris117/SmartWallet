import 'package:flutter/material.dart';
import 'create_account_page.dart';

class VoiceContinuePage extends StatefulWidget {
  const VoiceContinuePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const VoiceContinuePage());
  }

  @override
  State<VoiceContinuePage> createState() => _VoiceContinuePageState();
}

class _VoiceContinuePageState extends State<VoiceContinuePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App title / header
                Text(
                  'WalkYou',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Iniciar sesión / Registrarse',
                  style: theme.textTheme.labelSmall,
                ),

                const SizedBox(height: 18),

                // main card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '¡Hola de nuevo!',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Optional decorative image (replace with your asset)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: SizedBox(
                            height: 120,
                            child: Image.asset(
                              'assets/images/voice_page.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stack) {
                                // If the asset is missing, show a placeholder
                                return const Icon(
                                  Icons.phone_iphone,
                                  size: 72,
                                  color: Colors.blueAccent,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Email input
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

                      // Password input
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
                              color: Colors.grey[600],
                            ),
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

                      // Sign in button
                      ElevatedButton(
                        onPressed: () {
                          // Implement sign-in logic here
                        },
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
                          onPressed: () {
                            // TODO: implementar recuperación de contraseña
                          },
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
