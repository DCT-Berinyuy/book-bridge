import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.termsAndConditionsTitle),
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
            _buildSectionTitle(
              AppLocalizations.of(context)!.termsAcceptanceTitle,
            ),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsAcceptanceContent,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(
              AppLocalizations.of(context)!.termsMarketplaceTitle,
            ),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsMarketplaceContent,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(
              AppLocalizations.of(context)!.termsResponsibilitiesTitle,
            ),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsResponsibilitiesContent,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(
              AppLocalizations.of(context)!.termsPaymentsTitle,
            ),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsPaymentsContent,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(
              AppLocalizations.of(context)!.termsLiabilityTitle,
            ),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsLiabilityContent,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(AppLocalizations.of(context)!.termsChangesTitle),
            _buildSectionContent(
              AppLocalizations.of(context)!.termsChangesContent,
            ),
            const SizedBox(height: 40),
            Text(
              AppLocalizations.of(context)!.lastUpdated('February 2026'),
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
