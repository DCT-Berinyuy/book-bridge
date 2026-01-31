import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:book_bridge/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/screens/home_screen.dart';
import 'package:book_bridge/features/listings/presentation/screens/listing_details_screen.dart';
import 'package:book_bridge/features/listings/presentation/screens/sell_screen.dart';
import 'package:book_bridge/features/listings/presentation/screens/profile_screen.dart';
import 'package:book_bridge/features/listings/presentation/screens/search_screen.dart';
import 'package:book_bridge/core/presentation/widgets/scaffold_with_navbar.dart';
import 'package:book_bridge/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:book_bridge/injection_container.dart' as di;

/// App router configuration using go_router.
///
/// This configures all routes in the application and handles navigation
/// logic based on authentication state.
final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authViewModel = context.read<AuthViewModel>();
    final authState = authViewModel.authState;
    final location = state.matchedLocation;

    debugPrint('Router: Redirect check: loc=$location, state=$authState');

    // While initializing or loading, stay on current page (usually slash)
    if (authState == AuthState.initial || authState == AuthState.loading) {
      debugPrint('Router: Still loading auth, staying on $location');
      return null;
    }

    final isAuthenticated = authViewModel.isAuthenticated;
    final isGoingToAuth = location == '/sign-in' || location == '/sign-up';

    debugPrint(
      'Router: AuthStatus: authenticated=$isAuthenticated, isGoingToAuth=$isGoingToAuth',
    );

    // If not authenticated and not going to auth screen, redirect to sign-in
    if (!isAuthenticated && !isGoingToAuth) {
      debugPrint('Router: Redirecting unauthenticated user to /sign-in');
      return '/sign-in';
    }

    // If authenticated and trying to go to auth screen or splash, redirect to home
    if (isAuthenticated && (isGoingToAuth || location == '/')) {
      debugPrint('Router: Redirecting authenticated user to /home');
      return '/home';
    }

    debugPrint('Router: No redirection needed for $location');
    return null;
  },
  refreshListenable: di.getIt<AuthViewModel>(),
  routes: [
    // Splash/Landing route
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Sign In route
    GoRoute(
      path: '/sign-in',
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),

    // Sign Up route
    GoRoute(
      path: '/sign-up',
      name: 'signUp',
      builder: (context, state) => const SignUpScreen(),
    ),

    // Main Shell Route (with Bottom Navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Search Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // Sell Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sell',
              name: 'sell',
              builder: (context, state) => const SellScreen(),
            ),
          ],
        ),

        // Profile Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Listing Details Route (Full Screen, outside shell)
    GoRoute(
      path: '/listing/:id',
      name: 'listing',
      builder: (context, state) {
        final listingId = state.pathParameters['id']!;
        return ListingDetailsScreen(listingId: listingId);
      },
    ),

    // Edit Profile Route (Full Screen, outside shell)
    GoRoute(
      path: '/edit-profile',
      name: 'editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);

/// Splash screen that shows during initial auth check.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BookBridge',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
