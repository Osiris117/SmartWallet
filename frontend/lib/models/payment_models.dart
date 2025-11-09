// Modelos para la integración con Open Payments API

class WalletAddress {
  final String id;
  final String publicName;
  final String assetCode;
  final int assetScale;
  final String authServer;
  final String resourceServer;

  WalletAddress({
    required this.id,
    required this.publicName,
    required this.assetCode,
    required this.assetScale,
    required this.authServer,
    required this.resourceServer,
  });

  factory WalletAddress.fromJson(Map<String, dynamic> json) {
    return WalletAddress(
      id: json['id'] ?? '',
      publicName: json['publicName'] ?? '',
      assetCode: json['assetCode'] ?? '',
      assetScale: json['assetScale'] ?? 0,
      authServer: json['authServer'] ?? '',
      resourceServer: json['resourceServer'] ?? '',
    );
  }
}

class PaymentAmount {
  final String value;
  final String assetCode;
  final int assetScale;

  PaymentAmount({
    required this.value,
    required this.assetCode,
    required this.assetScale,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'assetCode': assetCode,
      'assetScale': assetScale,
    };
  }

  factory PaymentAmount.fromJson(Map<String, dynamic> json) {
    return PaymentAmount(
      value: json['value'] ?? '0',
      assetCode: json['assetCode'] ?? '',
      assetScale: json['assetScale'] ?? 0,
    );
  }
}

class IncomingPayment {
  final String id;
  final String walletAddress;
  final PaymentAmount incomingAmount;
  final String? receivedAmount;
  final bool completed;
  final DateTime createdAt;
  final DateTime? expiresAt;

  IncomingPayment({
    required this.id,
    required this.walletAddress,
    required this.incomingAmount,
    this.receivedAmount,
    required this.completed,
    required this.createdAt,
    this.expiresAt,
  });

  factory IncomingPayment.fromJson(Map<String, dynamic> json) {
    return IncomingPayment(
      id: json['id'] ?? '',
      walletAddress: json['walletAddress'] ?? '',
      incomingAmount: PaymentAmount.fromJson(json['incomingAmount'] ?? {}),
      receivedAmount: json['receivedAmount']?.toString(),
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }
}

class Quote {
  final String id;
  final String walletAddress;
  final String receiver;
  final PaymentAmount debitAmount;
  final PaymentAmount receiveAmount;
  final DateTime createdAt;
  final DateTime expiresAt;

  Quote({
    required this.id,
    required this.walletAddress,
    required this.receiver,
    required this.debitAmount,
    required this.receiveAmount,
    required this.createdAt,
    required this.expiresAt,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? '',
      walletAddress: json['walletAddress'] ?? '',
      receiver: json['receiver'] ?? '',
      debitAmount: PaymentAmount.fromJson(json['debitAmount'] ?? {}),
      receiveAmount: PaymentAmount.fromJson(json['receiveAmount'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().add(const Duration(hours: 1)).toIso8601String()),
    );
  }
}

class OutgoingPayment {
  final String id;
  final String walletAddress;
  final String quoteId;
  final PaymentAmount debitAmount;
  final PaymentAmount sentAmount;
  final bool completed;
  final DateTime createdAt;

  OutgoingPayment({
    required this.id,
    required this.walletAddress,
    required this.quoteId,
    required this.debitAmount,
    required this.sentAmount,
    required this.completed,
    required this.createdAt,
  });

  factory OutgoingPayment.fromJson(Map<String, dynamic> json) {
    return OutgoingPayment(
      id: json['id'] ?? '',
      walletAddress: json['walletAddress'] ?? '',
      quoteId: json['quoteId'] ?? '',
      debitAmount: PaymentAmount.fromJson(json['debitAmount'] ?? {}),
      sentAmount: PaymentAmount.fromJson(json['sentAmount'] ?? {}),
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class TransferRequest {
  final String senderWalletUrl;
  final String receiverWalletUrl;
  final String amount;
  final String currency;

  TransferRequest({
    required this.senderWalletUrl,
    required this.receiverWalletUrl,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderWalletUrl': senderWalletUrl,
      'receiverWalletUrl': receiverWalletUrl,
      'amount': amount,
      'currency': currency,
    };
  }
}

class TransferResponse {
  final bool success;
  final bool requiresAuthorization;
  final String? authorizationUrl;
  final String? grantId;
  final String? continueToken;
  final IncomingPayment? incomingPayment;
  final Quote? quote;
  final OutgoingPayment? outgoingPayment;
  final String message;

  TransferResponse({
    required this.success,
    this.requiresAuthorization = false,
    this.authorizationUrl,
    this.grantId,
    this.continueToken,
    this.incomingPayment,
    this.quote,
    this.outgoingPayment,
    required this.message,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    return TransferResponse(
      success: json['success'] ?? false,
      requiresAuthorization: json['requiresAuthorization'] ?? false,
      authorizationUrl: json['data']?['authorizationUrl'],
      grantId: json['data']?['grantId'],
      continueToken: json['data']?['continueToken'],
      incomingPayment: data?['incomingPayment'] != null 
          ? IncomingPayment.fromJson(data!['incomingPayment']) 
          : null,
      quote: data?['quote'] != null 
          ? Quote.fromJson(data!['quote']) 
          : null,
      outgoingPayment: data?['outgoingPayment'] != null 
          ? OutgoingPayment.fromJson(data!['outgoingPayment']) 
          : null,
      message: json['message'] ?? '',
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      error: json['error'],
      message: json['message'],
    );
  }
}
