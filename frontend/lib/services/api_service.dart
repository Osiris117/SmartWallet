// Servicio de API para comunicarse con el backend de SmartWallet
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_models.dart';

class ApiService {
  // URL del backend - cambiar según el entorno
  static const String baseUrl = 'http://localhost:3001/api';
  
  // Headers comunes
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Health check
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error en health check: $e');
      return false;
    }
  }

  // Obtener información de una wallet
  static Future<ApiResponse<WalletAddress>> getWalletInfo(String walletUrl) async {
    try {
      // Remover https:// si existe para el endpoint
      final cleanUrl = walletUrl.replaceAll('https://', '').replaceAll('http://', '');
      
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/$cleanUrl'),
        headers: _headers,
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['success'] == true) {
        return ApiResponse(
          success: true,
          data: WalletAddress.fromJson(json['data']),
        );
      } else {
        return ApiResponse(
          success: false,
          error: json['error'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Error de conexión: $e',
      );
    }
  }

  // Crear un incoming payment
  static Future<ApiResponse<IncomingPayment>> createIncomingPayment({
    required String receiverWalletUrl,
    required String amount,
    String? assetCode,
    int? assetScale,
  }) async {
    try {
      final body = {
        'receiverWalletUrl': receiverWalletUrl,
        'amount': amount,
        if (assetCode != null) 'assetCode': assetCode,
        if (assetScale != null) 'assetScale': assetScale,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/incoming-payment'),
        headers: _headers,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['success'] == true) {
        return ApiResponse(
          success: true,
          data: IncomingPayment.fromJson(json['data']['incomingPayment']),
        );
      } else {
        return ApiResponse(
          success: false,
          error: json['error'] ?? 'Error creando incoming payment',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Error de conexión: $e',
      );
    }
  }

  // Crear una cotización
  static Future<ApiResponse<Quote>> createQuote({
    required String senderWalletUrl,
    required String receiverPaymentUrl,
  }) async {
    try {
      final body = {
        'senderWalletUrl': senderWalletUrl,
        'receiverPaymentUrl': receiverPaymentUrl,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/quote'),
        headers: _headers,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['success'] == true) {
        return ApiResponse(
          success: true,
          data: Quote.fromJson(json['data']['quote']),
        );
      } else {
        return ApiResponse(
          success: false,
          error: json['error'] ?? 'Error creando quote',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Error de conexión: $e',
      );
    }
  }

  // Transferencia simplificada (flujo completo)
  static Future<TransferResponse> simpleTransfer({
    required String senderWalletUrl,
    required String receiverWalletUrl,
    required String amount,
    required String currency,
  }) async {
    try {
      print('🌐 Llamando a API: $baseUrl/transfer/simple');
      
      final transferRequest = TransferRequest(
        senderWalletUrl: senderWalletUrl,
        receiverWalletUrl: receiverWalletUrl,
        amount: amount,
        currency: currency,
      );

      print('📦 Request body: ${jsonEncode(transferRequest.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/transfer/simple'),
        headers: _headers,
        body: jsonEncode(transferRequest.toJson()),
      ).timeout(const Duration(seconds: 30));

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TransferResponse.fromJson(json);
      } else {
        // Error del servidor
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return TransferResponse(
            success: false,
            message: json['error'] ?? json['message'] ?? 'Error del servidor (${response.statusCode})',
          );
        } catch (e) {
          return TransferResponse(
            success: false,
            message: 'Error del servidor (${response.statusCode}): ${response.body}',
          );
        }
      }
      
    } catch (e) {
      print('❌ Error en simpleTransfer: $e');
      return TransferResponse(
        success: false,
        message: 'Error de conexión: $e. Asegúrate de que el backend esté corriendo en $baseUrl',
      );
    }
  }

  // Completar outgoing payment después de autorización
  static Future<ApiResponse<OutgoingPayment>> completeOutgoingPayment({
    required String senderWalletUrl,
    required String grantId,
    required String continueToken,
    required String quoteId,
  }) async {
    try {
      final body = {
        'senderWalletUrl': senderWalletUrl,
        'grantId': grantId,
        'continueToken': continueToken,
        'quoteId': quoteId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/outgoing-payment/complete'),
        headers: _headers,
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && json['success'] == true) {
        return ApiResponse(
          success: true,
          data: OutgoingPayment.fromJson(json['data']['outgoingPayment']),
          message: json['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          error: json['error'] ?? 'Error completando pago',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Error de conexión: $e',
      );
    }
  }
}
