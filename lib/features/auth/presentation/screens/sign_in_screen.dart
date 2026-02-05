import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:book_bridge/core/presentation/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// Sign In screen for user authentication.
///
/// Provides a form for users to sign in with their email and password.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Save reference to avoid accessing context in dispose()
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    // Add a listener to handle UI feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = context.read<AuthViewModel>();
      _authViewModel.addListener(_onAuthStateChanged);
    });
  }

  @override
  void dispose() {
    // Remove the listener before disposing using saved reference
    _authViewModel.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    // Check if the widget is still mounted before accessing context
    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.authState == AuthState.error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.errorMessage ??
                  AppLocalizations.of(context)!.anUnknownErrorOccurredPeriod,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    } else if (authViewModel.authStatus == AuthStatus.passwordResetSent) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.successMessage ??
                  AppLocalizations.of(
                    context,
                  )!.passwordResetLinkSentExclamation_mark,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      authViewModel.clearStatus();
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailDialogController = TextEditingController();
    final authViewModel = context.read<AuthViewModel>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.resetPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.enterYourEmailAddressToReceiveAPasswordResetLinkPeriod,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailDialogController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: 'student@university.cm',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailDialogController.text.isNotEmpty) {
                  authViewModel.sendPasswordResetEmail(
                    email: emailDialogController.text.trim(),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.sendLink),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            color: const Color(0xFF1A4D8C), // Scholar Blue
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (context.canPop())
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.signIn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const LanguageSwitcher(),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Branding & Headline
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/logo.png', height: 100),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.bookbridgeColonKnowledgeForAll,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436), // Ink Black
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.democratizingAccessToAffordableBooksInCameroonPeriod,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF95A5A6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Form Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        Text(
                          AppLocalizations.of(context)!.emailAddress,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          enabled: authViewModel.authState != AuthState.loading,
                          decoration: InputDecoration(
                            hintText: 'student@university.cm',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(
                                context,
                              )!.emailIsRequired;
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value!)) {
                              return AppLocalizations.of(
                                context,
                              )!.enterAValidEmailAddress;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          enabled: authViewModel.authState != AuthState.loading,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: const Icon(Icons.visibility),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordIsRequired;
                            }
                            if (value!.length < 6) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordMustBeAtLeast6Characters;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _showForgotPasswordDialog(context),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.forgotPasswordQuestion_mark,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A4D8C), // Scholar Blue
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Sign In button
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                authViewModel.authState == AuthState.loading
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      authViewModel.signIn(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF1A4D8C,
                              ), // Scholar Blue
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: authViewModel.authState == AuthState.loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.signIn,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sign Up link and local context indicator
                  Column(
                    children: [
                      const SizedBox(height: 24),

                      // Sign Up link
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.donBackslashApostropheTHaveAnAccountQuestion_mark,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/sign-up'),
                        child: Text(
                          AppLocalizations.of(context)!.signUp,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF13EC5B), // Primary green
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Local Context Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'CAMEROON • FCFA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
