enum PaymentGateway { mada, visaMastercard, applePay, googlePay, stcPay }

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;

  const PaymentResult({required this.success, this.transactionId, this.errorMessage});
}

abstract class PaymentGatewayService {
  String get name;
  PaymentGateway get type;
  Future<bool> isAvailable();
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  });
  Future<PaymentResult> refundPayment(String transactionId);
}

class MadaService implements PaymentGatewayService {
  @override
  String get name => 'Mada';

  @override
  PaymentGateway get type => PaymentGateway.mada;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async => const PaymentResult(success: false, errorMessage: 'Mada SDK required');

  @override
  Future<PaymentResult> refundPayment(String transactionId) async =>
      const PaymentResult(success: false, errorMessage: 'Mada SDK required');
}

class VisaMastercardService implements PaymentGatewayService {
  @override
  String get name => 'Visa/Mastercard';

  @override
  PaymentGateway get type => PaymentGateway.visaMastercard;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async => const PaymentResult(success: false, errorMessage: 'Stripe/PayFort SDK required');

  @override
  Future<PaymentResult> refundPayment(String transactionId) async =>
      const PaymentResult(success: false, errorMessage: 'Stripe/PayFort SDK required');
}

class ApplePayService implements PaymentGatewayService {
  @override
  String get name => 'Apple Pay';

  @override
  PaymentGateway get type => PaymentGateway.applePay;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async => const PaymentResult(success: false, errorMessage: 'Apple Pay merchant account required');

  @override
  Future<PaymentResult> refundPayment(String transactionId) async =>
      const PaymentResult(success: false, errorMessage: 'Apple Pay merchant account required');
}

class GooglePayService implements PaymentGatewayService {
  @override
  String get name => 'Google Pay';

  @override
  PaymentGateway get type => PaymentGateway.googlePay;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async => const PaymentResult(success: false, errorMessage: 'Google Pay merchant account required');

  @override
  Future<PaymentResult> refundPayment(String transactionId) async =>
      const PaymentResult(success: false, errorMessage: 'Google Pay merchant account required');
}

class StcPayService implements PaymentGatewayService {
  @override
  String get name => 'STC Pay';

  @override
  PaymentGateway get type => PaymentGateway.stcPay;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async => const PaymentResult(success: false, errorMessage: 'STC Pay agreement required');

  @override
  Future<PaymentResult> refundPayment(String transactionId) async =>
      const PaymentResult(success: false, errorMessage: 'STC Pay agreement required');
}

class PaymentGatewayFactory {
  static final Map<PaymentGateway, PaymentGatewayService> _gateways = {
    PaymentGateway.mada: MadaService(),
    PaymentGateway.visaMastercard: VisaMastercardService(),
    PaymentGateway.applePay: ApplePayService(),
    PaymentGateway.googlePay: GooglePayService(),
    PaymentGateway.stcPay: StcPayService(),
  };

  static PaymentGatewayService get(PaymentGateway type) => _gateways[type]!;
}
