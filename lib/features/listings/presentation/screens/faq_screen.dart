import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: const Color(0xFF1A4D8C),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryHeader('General'),
          _buildFaqItem(
            'What is BookBridge?',
            'BookBridge is a peer-to-peer marketplace designed specifically for students in Cameroon to buy and sell used physical books at affordable prices.',
          ),
          _buildFaqItem(
            'How do I create an account?',
            'You can sign up using your email address or quickly sign in with your Google account. After signing in, you\'ll need to complete your profile with a few details like your locality and WhatsApp number.',
          ),

          const SizedBox(height: 24),
          _buildCategoryHeader('Buying Books'),
          _buildFaqItem(
            'How do I buy a book?',
            'Browse the listings on the Home screen or use the search bar. When you find a book you like, tap on it to see details, then use the "Contact Seller" button to message them via WhatsApp to arrange the purchase.',
          ),
          _buildFaqItem(
            'How do I pay for a book?',
            'Most transactions happen directly between the buyer and seller. You can pay in cash during a physical meeting or via Mobile Money if both parties agree. Always verify the book\'s condition before paying.',
          ),
          _buildFaqItem(
            'Can I see books near me?',
            'Yes! The "Your nearby books" section on the Home screen uses your location to show books available in your immediate vicinity, sorted by distance.',
          ),

          const SizedBox(height: 24),
          _buildCategoryHeader('Selling Books'),
          _buildFaqItem(
            'How do I list a book for sale?',
            'Tap the "Sell" button in the bottom navigation bar. Upload a clear photo of the book, enter the title, author, price, and condition, then submit the listing.',
          ),
          _buildFaqItem(
            'Is there a fee for selling?',
            'Currently, listing books on BookBridge is free for individual students. We want to make it as easy as possible for you to recycle your educational resources.',
          ),
          _buildFaqItem(
            'What is "Buy-Back Eligible"?',
            'Some listings from verified bookshops or the platform itself may be eligible for buy-back. This means you can sell the book back to the source at a pre-determined price once you\'re finished with it.',
          ),

          const SizedBox(height: 24),
          _buildCategoryHeader('Safety & Trust'),
          _buildFaqItem(
            'How do I know a seller is trustworthy?',
            'Check for the "Verified" badge on listings. For individual students, we encourage meeting in safe, public locations like your school campus or a busy library to complete transactions.',
          ),
          _buildFaqItem(
            'What should I do if there\'s a problem?',
            'If you encounter any issues with a transaction or another user, please use the "Feedback" or "Contact Us" options in your profile to report it to our team.',
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A4D8C),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
