import 'package:book_bridge/features/payments/presentation/viewmodels/payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentBottomSheet extends StatefulWidget {
  final int amount;
  final String title;
  final String externalReference;
  final VoidCallback onSuccess;

  const PaymentBottomSheet({
    super.key,
    required this.amount,
    required this.title,
    required this.externalReference,
    required this.onSuccess,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Total: ${widget.amount} FCFA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (viewModel.state == PaymentState.initial) ...[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (6xx...)',
                      hintText: 'e.g. 677777777',
                      prefixText: '+237 ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (value.length < 9) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      viewModel.collectPayment(
                        amount: widget.amount,
                        phoneNumber: '237${_phoneController.text}',
                        externalReference: widget.externalReference,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Pay Now'),
                ),
              ] else if (viewModel.state == PaymentState.processing) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 16),
                const Text(
                  'Initiating transaction...',
                  textAlign: TextAlign.center,
                ),
              ] else if (viewModel.state == PaymentState.pendingUser) ...[
                const Icon(
                  Icons.touch_app_outlined,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please confirm the payment request on your phone!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => viewModel.checkStatus(),
                  child: const Text('I have paid'),
                ),
              ] else if (viewModel.state == PaymentState.success) ...[
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    widget.onSuccess();
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'),
                ),
              ] else if (viewModel.state == PaymentState.failure) ...[
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage ?? 'An error occurred',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => viewModel.reset(),
                  child: const Text('Try Again'),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
