import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/transaction_success_page.dart';
import 'package:smart_wallet/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMoneyPage extends StatefulWidget {
  final double? initialAmount;
  
  const SendMoneyPage({Key? key, this.initialAmount}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SendMoneyPage());
  }

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _urlController = TextEditingController();
  final _amountController = TextEditingController();
  
  String _selectedCurrency = 'USD';
  bool _isRadioActive = false;
  bool _isLoading = false;

  final String _senderWalletUrl = 'https://ilp.interledger-test.dev/arely';

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount!.toString();
    }
  }

  void _toggleRadio() {
    setState(() {
      _isRadioActive = !_isRadioActive;
    });
  }

  Future<void> _sendMoney() async {
    if (_urlController.text.trim().isEmpty) {
      _showError('Por favor ingresa la URL del receptor');
      return;
    }

    if (_amountController.text.trim().isEmpty) {
      _showError('Por favor ingresa un monto');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showError('Por favor ingresa un monto válido');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String receiverUrl = _urlController.text.trim();
      if (!receiverUrl.startsWith('http')) {
        receiverUrl = 'https://$receiverUrl';
      }

      print('🔄 Iniciando transferencia...');
      print('📤 Remitente: $_senderWalletUrl');
      print('📥 Receptor: $receiverUrl');
      print('💰 Monto original: $amount $_selectedCurrency');

      final amountInBaseUnits = (amount * 100).toInt().toString();
      print('💵 Monto en unidades base: $amountInBaseUnits');

      final response = await ApiService.simpleTransfer(
        senderWalletUrl: _senderWalletUrl,
        receiverWalletUrl: receiverUrl,
        amount: amountInBaseUnits,
        currency: _selectedCurrency,
      );

      print('📨 Respuesta recibida: success=${response.success}, message=${response.message}');

      setState(() => _isLoading = false);

      if (response.success) {
        if (response.requiresAuthorization && response.authorizationUrl != null) {
          print('🔐 Requiere autorización');
          _showAuthorizationDialog(
            response.authorizationUrl!,
            response.grantId!,
            response.continueToken!,
            response.quote!.id,
            receiverUrl,
            amount,
          );
        } else if (response.outgoingPayment != null) {
          print('✅ Pago completado');
          _navigateToSuccess(receiverUrl, amount);
        }
      } else {
        print('❌ Error: ${response.message}');
        _showError(response.message.isEmpty ? 'Error desconocido al procesar la transferencia' : response.message);
      }
    } catch (e, stackTrace) {
      setState(() => _isLoading = false);
      print('❌ Excepción capturada: $e');
      print('Stack trace: $stackTrace');
      _showError('Error al procesar la transferencia: $e');
    }
  }

  void _showAuthorizationDialog(
    String authUrl,
    String grantId,
    String continueToken,
    String quoteId,
    String receiverUrl,
    double amount,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Autorización Requerida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Para completar la transferencia, debes autorizar el pago en tu navegador.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Icon(Icons.security, size: 48, color: Colors.blue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(authUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                Navigator.pop(context);
                
                _showWaitingDialog(grantId, continueToken, quoteId, receiverUrl, amount);
              } else {
                _showError('No se pudo abrir el navegador');
              }
            },
            child: const Text('Autorizar'),
          ),
        ],
      ),
    );
  }

  void _showWaitingDialog(
    String grantId,
    String continueToken,
    String quoteId,
    String receiverUrl,
    double amount,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Esperando Autorización'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Presiona "Completar" después de autorizar en el navegador'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _completePayment(grantId, continueToken, quoteId, receiverUrl, amount);
            },
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }

  Future<void> _completePayment(
    String grantId,
    String continueToken,
    String quoteId,
    String receiverUrl,
    double amount,
  ) async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.completeOutgoingPayment(
        senderWalletUrl: _senderWalletUrl,
        grantId: grantId,
        continueToken: continueToken,
        quoteId: quoteId,
      );

      setState(() => _isLoading = false);

      if (response.success) {
        _navigateToSuccess(receiverUrl, amount);
      } else {
        _showError(response.error ?? 'Error completando el pago');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: $e');
    }
  }

  void _navigateToSuccess(String receiverUrl, double amount) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TransactionSuccessPage(
          storeName: 'SmartWallet Transfer',
          transactionNumber: '${DateTime.now().millisecondsSinceEpoch}',
          transactionDate: DateTime.now(),
          referenceNumber: '${DateTime.now().microsecondsSinceEpoch}',
          sourceUser: _senderWalletUrl,
          destinationNumber: receiverUrl,
          destinationAlias: receiverUrl.split('/').last,
          amount: amount,
          currency: _selectedCurrency,
          notes: 'Transferencia vía Interledger',
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
              child: Image.asset('assets/images/Logo.png', height: 24),
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF1A2341),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/Logo.png', height: 32),
                ],
              ),
              const SizedBox(height: 24),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          color: _isRadioActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
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

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          items: ['USD'].map((String value) {
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _sendMoney,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
