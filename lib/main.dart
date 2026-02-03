import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_bridge/core/theme/app_theme.dart';
import 'package:book_bridge/injection_container.dart' as di;
import 'package:book_bridge/config/router.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/home_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/listing_details_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/sell_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/search_viewmodel.dart';
import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:book_bridge/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: AppConfig.supabaseUrl.isNotEmpty
        ? AppConfig.supabaseUrl
        : String.fromEnvironment(
            'SUPABASE_URL',
            defaultValue: 'https://jacnsvcwmhoicuuzmrmr.supabase.co',
          ),
    anonKey: AppConfig.supabaseAnonKey.isNotEmpty
        ? AppConfig.supabaseAnonKey
        : String.fromEnvironment(
            'SUPABASE_ANON_KEY',
            defaultValue:
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImphY25zdmN3bWhvaWN1dXptcm1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzOTAwOTEsImV4cCI6MjA4NDk2NjA5MX0.utrEmY1iIEwYCmbvLt96sCn1cXGRLFGWc7Mc9UmbILk',
          ),
  );

  // Initialize dependency injection
  await di.setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => di.getIt<AuthViewModel>(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => di.getIt<HomeViewModel>(),
        ),
        ChangeNotifierProvider<ListingDetailsViewModel>(
          create: (_) => di.getIt<ListingDetailsViewModel>(),
        ),
        ChangeNotifierProvider<SellViewModel>(
          create: (_) => di.getIt<SellViewModel>(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => di.getIt<ProfileViewModel>(),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (_) => di.getIt<SearchViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'BookBridge: Social Venture', //TODO: translate
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
