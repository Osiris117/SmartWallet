import 'package:flutter/material.dart';
import 'package:smart_wallet/congrats_page.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SendMoneyPage());
  }

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _urlController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCurrency = 'MXN';
  bool _isRadioActive = false;

  void _toggleRadio() {
    setState(() {
      _isRadioActive = !_isRadioActive;
    });
    // Aquí iría la lógica real de activar/desactivar radio
  }

  @override
  void dispose() {
    _urlController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/Logof.png', height: 24),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications_none, color: Colors.black87),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Enviar',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF1A2341),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/Logof.png', height: 32),
                ],
              ),
              const SizedBox(height: 24),
              
              // URL Field with radio button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                      BoxShadow(
                      color: Color.fromRGBO(0,0,0,0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'URL Enlace',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRadioActive ? Color.fromRGBO(59,130,246,0.1) : Colors.transparent,
                        ),
                        child: Icon(
                          Icons.radio_button_checked,
                          color: _isRadioActive ? Colors.blue : Colors.grey,
                        ),
                      ),
                      onPressed: _toggleRadio,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Amount and Currency Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0,0,0,0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Monto',
                            prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1, color: Colors.grey),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          items: ['MXN', 'USD', 'EUR'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.language, color: Colors.grey),
                        onPressed: () {
                          // Aquí iría la lógica de conversión de moneda
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Send Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Simulación de envío exitoso
                  // Tras envío exitoso mostramos la pantalla de felicitación (video)
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const CongratsPage()),
                  );
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}