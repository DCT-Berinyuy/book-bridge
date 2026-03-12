import 'package:flutter/material.dart';
import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsAndConditionsTitle),
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
            _buildSectionTitle(context, l10n.termsAcceptanceTitle),
            _buildSectionContent(l10n.termsAcceptanceContent),
            const SizedBox(height: 20),
            _buildSectionTitle(context, l10n.termsMarketplaceTitle),
            _buildSectionContent(l10n.termsMarketplaceContent),
            const SizedBox(height: 20),
            _buildSectionTitle(context, l10n.termsResponsibilitiesTitle),
            _buildSectionContent(l10n.termsResponsibilitiesContent),
            const SizedBox(height: 20),
            _buildSectionTitle(context, l10n.termsPaymentsTitle),
            _buildSectionContent(l10n.termsPaymentsContent),
            const SizedBox(height: 20),
            _buildSectionTitle(context, l10n.termsLiabilityTitle),
            _buildSectionContent(l10n.termsLiabilityContent),
            const SizedBox(height: 20),
            _buildSectionTitle(context, l10n.termsChangesTitle),
            _buildSectionContent(l10n.termsChangesContent),
            const SizedBox(height: 40),
            Text(
              l10n.lastUpdated('February 2026'),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(content, style: const TextStyle(fontSize: 15, height: 1.5));
  }
}
