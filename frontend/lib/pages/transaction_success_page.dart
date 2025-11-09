import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionSuccessPage extends StatelessWidget {
  final String storeName;
  final String transactionNumber;
  final DateTime transactionDate;
  final String referenceNumber;
  final String sourceUser;
  final String destinationNumber;
  final String destinationAlias;
  final String notes;
  final double amount;
  final String currency;

  const TransactionSuccessPage({
    Key? key,
    required this.storeName,
    required this.transactionNumber,
    required this.transactionDate,
    required this.referenceNumber,
    required this.sourceUser,
    required this.destinationNumber,
    required this.destinationAlias,
    this.notes = '',
    required this.amount,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Row(
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
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.blue[50],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.notifications_none,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Success Message
                        Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '¡Transferencia Exitossa!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Store Name and Transaction Number
                        Text(
                          storeName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Número de transacción: $transactionNumber',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const Divider(height: 32),

                        // Transaction Details
                        _buildDetailRow('Fecha y hora', 
                          DateFormat('dd \'de\' MMM, yyyy | h:mm a')
                            .format(transactionDate)),
                        _buildDetailRow('Número de referencia', referenceNumber),
                        _buildDetailRow('Origen de los fondos', sourceUser),
                        _buildDetailRow('Número de destino', destinationNumber),
                        _buildDetailRow('Alias del destinatario', destinationAlias),
                        if (notes.isNotEmpty)
                          _buildDetailRow('Notas por compra', notes),
                        
                        const Divider(height: 32),

                        // Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total de la transación',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: '\$'),
                                  TextSpan(
                                    text: amount.toStringAsFixed(2),
                                  ),
                                  TextSpan(
                                    text: ' $currency',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Share Button
                        OutlinedButton.icon(
                          onPressed: () {
                            // Implementar funcionalidad de compartir
                          },
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Compartir'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Bottom Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home, 'Inicio', true),
                    _buildNavItem(Icons.access_time, 'Actividad', false),
                    _buildNavItem(Icons.person_outline, 'Perfil', false),
                    _buildNavItem(Icons.settings_outlined, 'Configuración', false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}