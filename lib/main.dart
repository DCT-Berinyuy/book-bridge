import 'package:flutter/material.dart';
import 'package:book_bridge/l10n/app_localizations.dart';
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
import 'package:book_bridge/features/notifications/presentation/viewmodels/notifications_viewmodel.dart';
import 'package:book_bridge/features/payments/presentation/viewmodels/payment_viewmodel.dart';
import 'package:book_bridge/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/locale_viewmodel.dart';
import 'package:book_bridge/features/chat/presentation/viewmodels/chat_viewmodel.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: AppConfig.supabaseUrl.isNotEmpty
        ? AppConfig.supabaseUrl
        : const String.fromEnvironment('SUPABASE_URL'),
    anonKey: AppConfig.supabaseAnonKey.isNotEmpty
        ? AppConfig.supabaseAnonKey
        : const String.fromEnvironment('SUPABASE_ANON_KEY'),
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
        ChangeNotifierProvider<NotificationsViewModel>(
          create: (_) => di.getIt<NotificationsViewModel>(),
        ),
        ChangeNotifierProvider<PaymentViewModel>(
          create: (_) => di.getIt<PaymentViewModel>(),
        ),
        ChangeNotifierProvider<FavoritesViewModel>(
          create: (_) => di.getIt<FavoritesViewModel>(),
        ),
        ChangeNotifierProvider<ChatViewModel>(
          create: (_) => di.getIt<ChatViewModel>(),
        ),
        ChangeNotifierProvider<LocaleViewModel>(
          create: (_) => LocaleViewModel(),
        ),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, localeViewModel, _) {
          return MaterialApp.router(
            title: 'BookBridge: Social Venture',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeViewModel.locale,
          );
        },
      ),
    );
  }
}
