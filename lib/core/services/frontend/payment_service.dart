import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';

class PaymentService {
  static final _razorpay = Razorpay();
  
  static Future<void> initialize() async {
    // Initialize Stripe
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
    await Stripe.instance.applySettings();

    // Initialize Razorpay handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  static Future<void> makeStripePayment({
    required double amount,
    required String currency,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(amount, currency);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Speak NFT',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: CupertinoColors.systemBackground,
              primary: CupertinoColors.activeBlue,
              componentBackground: CupertinoColors.secondarySystemBackground,
            ),
          ),
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      onSuccess('Payment successful');
    } catch (e) {
      onError('Payment failed: $e');
    }
  }

  static Future<void> makeWalletPayment({
    required bool isApplePay,
    required double amount,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    final provider = isApplePay ? PayProvider.apple_pay : PayProvider.google_pay;
    final paymentConfig = await PaymentConfiguration.fromAsset(
      isApplePay
          ? 'default_payment_profile_apple_pay.json'
          : 'default_payment_profile_google_pay.json',
    );
    final Pay payClient = Pay({
      provider: paymentConfig,
    });

    try {
      await payClient.showPaymentSelector(
        provider,
        [
          PaymentItem(
            label: 'NFT Purchase',
            amount: amount.toString(),
            status: PaymentItemStatus.final_price,
          )
        ],
      );
      onSuccess('Payment successful');
    } catch (e) {
      onError('Payment failed: $e');
    }
  }

  static void makeRazorPayPayment({
    required double amount,
    required String currency,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    final options = {
      'key': dotenv.env['RAZORPAY_KEY'],
      'amount': (amount * 100).toInt(),
      'name': 'Speak NFT',
      'description': 'Voice NFT Purchase',
      'currency': currency,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      onError('Payment failed: $e');
    }
  }

  static Future<Map<String, dynamic>> _createPaymentIntent(
    double amount,
    String currency,
  ) async {
    // Implement your backend call to create payment intent
    // This should be done through your server
    throw UnimplementedError(
      'Implement backend call to create Stripe payment intent',
    );
  }

  static void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment
  }

  static void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
  }

  static void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  static void dispose() {
    _razorpay.clear();
  }
} 