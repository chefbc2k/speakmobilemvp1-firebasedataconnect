import 'package:flutter/material.dart';
import '../../core/services/frontend/payment_service.dart';

class PaymentButton extends StatefulWidget {
  final PaymentMethod paymentMethod;
  final double amount;

  const PaymentButton({
    super.key,
    required this.paymentMethod,
    required this.amount,
  });

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isProcessing ? null : () => _handlePayment(context),
      child: _isProcessing 
          ? const CircularProgressIndicator()
          : Text('Pay with ${widget.paymentMethod.name}'),
    );
  }

  Future<void> _handlePayment(BuildContext context) async {
    if (!mounted) return;

    setState(() => _isProcessing = true);

    try {
      switch (widget.paymentMethod) {
        case PaymentMethod.stripe:
          await PaymentService.makeStripePayment(
            amount: widget.amount,
            currency: 'USD',
            onSuccess: (message) => _showSuccess(context, message),
            onError: (error) => _showError(context, error),
          );
          break;
          
        case PaymentMethod.applePay:
          await PaymentService.makeWalletPayment(
            isApplePay: true,
            amount: widget.amount,
            onSuccess: (message) => _showSuccess(context, message),
            onError: (error) => _showError(context, error),
          );
          break;
          
        case PaymentMethod.googlePay:
          await PaymentService.makeWalletPayment(
            isApplePay: false,
            amount: widget.amount,
            onSuccess: (message) => _showSuccess(context, message),
            onError: (error) => _showError(context, error),
          );
          break;
          
        case PaymentMethod.razorPay:
          PaymentService.makeRazorPayPayment(
            amount: widget.amount,
            currency: 'USD',
            onSuccess: (message) => _showSuccess(context, message),
            onError: (error) => _showError(context, error),
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccess(BuildContext context, String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(BuildContext context, String error) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }
}

enum PaymentMethod {
  stripe,
  applePay,
  googlePay,
  razorPay,
} 