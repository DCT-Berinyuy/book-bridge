import 'package:book_bridge/features/payments/presentation/viewmodels/payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/l10n/app_localizations.dart';

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

  String _getMedium(String phone) {
    // Cameroon Mobile Money Prefixes:
    // MTN: 67, 68, 650, 651, 652, 653, 654
    // Orange: 69, 655, 656, 657, 658, 659
    if (phone.startsWith('67') || phone.startsWith('68')) return 'mobile money';
    if (phone.startsWith('69')) return 'orange money';
    if (phone.startsWith('65')) {
      if (phone.length >= 3) {
        final thirdDigit = int.tryParse(phone[2]) ?? 0;
        if (thirdDigit <= 4) return 'mobile money';
        return 'orange money';
      }
    }
    return 'mobile money'; // Default to mobile money
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
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
                    AppLocalizations.of(context)!.totalLabel(widget.amount),
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
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.phoneNumberLabel,
                          hintText: AppLocalizations.of(
                            context,
                          )!.phoneNumberHint,
                          prefixText: '+237 ',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.fieldRequired;
                          }
                          if (value.length < 9) {
                            return AppLocalizations.of(context)!.invalidNumber;
                          }
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
                            phoneNumber: _phoneController.text,
                            externalReference: widget.externalReference,
                            medium: _getMedium(_phoneController.text),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(AppLocalizations.of(context)!.payNow),
                    ),
                  ] else if (viewModel.state == PaymentState.processing) ...[
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.initiatingTransaction,
                      textAlign: TextAlign.center,
                    ),
                  ] else if (viewModel.state == PaymentState.pendingUser) ...[
                    const Icon(
                      Icons.touch_app_outlined,
                      size: 64,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.confirmPaymentPrompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => viewModel.checkStatus(),
                      child: Text(AppLocalizations.of(context)!.iHavePaid),
                    ),
                  ] else if (viewModel.state == PaymentState.success) ...[
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.paymentSuccessful,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        widget.onSuccess();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.continueButton),
                    ),
                  ] else if (viewModel.state == PaymentState.failure) ...[
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage ??
                          AppLocalizations.of(context)!.unknownError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => viewModel.reset(),
                      child: Text(AppLocalizations.of(context)!.tryAgain),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
