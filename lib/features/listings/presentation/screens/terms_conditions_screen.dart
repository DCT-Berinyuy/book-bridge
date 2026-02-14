import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: const Color(0xFF1A4D8C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Acceptance of Terms'),
            _buildSectionContent(
              'By accessing or using the BookBridge application, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use our service.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('2. Marketplace Rules'),
            _buildSectionContent(
              'BookBridge is a platform that facilitates the sale and purchase of used books between users. We are not a party to the actual transactions between buyers and sellers.\n\n'
              '• Sellers are responsible for the accuracy of their listings.\n'
              '• Buyers are responsible for verifying the condition of the books before purchase.\n'
              '• All transactions are made directly between users.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('3. User Responsibilities'),
            _buildSectionContent(
              'You must provide accurate information when creating an account and listing books. You are prohibited from posting content that is illegal, offensive, or infringing on the rights of others.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('4. Payments'),
            _buildSectionContent(
              'Payments for books are generally handled in cash upon delivery or via direct mobile money transfer between the buyer and seller. BookBridge may offer integrated payment solutions (like CamPay) for specific services or donations.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('5. Limitation of Liability'),
            _buildSectionContent(
              'BookBridge is provided "as is" without any warranties. We are not liable for any disputes, losses, or damages arising from your use of the application or transactions with other users.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('6. Changes to Terms'),
            _buildSectionContent(
              'We reserve the right to modify these terms at any time. Your continued use of the application following any changes constitutes acceptance of the new terms.',
            ),
            const SizedBox(height: 40),
            Text(
              'Last updated: February 2026',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A4D8C),
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(content, style: const TextStyle(fontSize: 15, height: 1.5));
  }
}
