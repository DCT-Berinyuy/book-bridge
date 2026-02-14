import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            _buildSectionTitle('1. Introduction'),
            _buildSectionContent(
              'Welcome to BookBridge. We value your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you visit our application and tell you about your privacy rights.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('2. Data We Collect'),
            _buildSectionContent(
              'We may collect, use, store and transfer different kinds of personal data about you which we have grouped together as follows:\n\n'
              '• Identity Data: Name, username or similar identifier.\n'
              '• Contact Data: Email address and telephone numbers (including WhatsApp).\n'
              '• Technical Data: IP address, login data, browser type and version, time zone setting and location.\n'
              '• Profile Data: Your username, password, listings made by you, your interests, and favorites.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('3. How We Use Your Data'),
            _buildSectionContent(
              'We only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:\n\n'
              '• To register you as a new user.\n'
              '• To facilitate the peer-to-peer marketplace (connecting buyers and sellers).\n'
              '• To improve our application, services, and user experience.\n'
              '• To manage our relationship with you.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('4. Data Sharing'),
            _buildSectionContent(
              'When you list a book, your contact information (like your WhatsApp number) will be shared with potential buyers to facilitate the transaction. We do not sell your personal data to third parties for marketing purposes.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('5. Data Security'),
            _buildSectionContent(
              'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('6. Your Rights'),
            _buildSectionContent(
              'You have the right to request access to, correction of, or erasure of your personal data. You can manage most of your data directly through your profile settings in the application.',
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
