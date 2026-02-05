import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:book_bridge/core/presentation/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// Sign Up screen for new user registration.
///
/// Provides a form for users to create a new account with email, password, and full name.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _localityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _fullNameController.dispose();
    _emailController.dispose();
    _localityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    } else if (authViewModel.authState == AuthState.authenticated) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              )!.signUpSuccessfulExclamation_markWelcomePeriod,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
    }
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
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/sign-in'),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset('assets/logo.png', height: 100),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.connectingStudentsCommaAuthorsCommaAndBookshopsToEndLearningPovertyPeriod,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Full Name
                        Text(
                          AppLocalizations.of(context)!.fullName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _fullNameController,
                          enabled: authViewModel.authState != AuthState.loading,
                          decoration: InputDecoration(
                            hintText: 'e.g. John Doe',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(
                                context,
                              )!.fullNameIsRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.schoolForward_slashPersonalEmail,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
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
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
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
                        const SizedBox(height: 16),

                        // Locality
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.localityForward_slashNeighborhood,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _localityController,
                          enabled: authViewModel.authState != AuthState.loading,
                          decoration: InputDecoration(
                            hintText: 'e.g. Molyko, Buea',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return AppLocalizations.of(
                                context,
                              )!.localityIsRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        Text(
                          AppLocalizations.of(context)!.password,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          enabled: authViewModel.authState != AuthState.loading,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            )!.minPeriod6Characters,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
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
                        const SizedBox(height: 32),

                        // Sign Up button
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
                                      authViewModel.signUp(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text
                                            .trim(),
                                        fullName: _fullNameController.text
                                            .trim(),
                                        locality: _localityController.text
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
                                    AppLocalizations.of(context)!.signUp,
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

                  // Footer
                  Column(
                    children: [
                      const SizedBox(height: 16),

                      // FCFA indicator
                      Text(
                        AppLocalizations.of(context)!.pricesAreListedInFcfa,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A4D8C), // Scholar Blue
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In link
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.alreadyHaveAnAccountQuestion_mark,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/sign-in'),
                        child: Text(
                          AppLocalizations.of(context)!.logIn,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF13EC5B), // Scholar Blue
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Home indicator
                      Container(
                        width: 96,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A4D8C).withValues(
                            alpha: 0.2,
                          ), // Primary green with opacity
                          borderRadius: BorderRadius.circular(2),
                        ),
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
