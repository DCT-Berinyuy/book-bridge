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

  @override
  void initState() {
    super.initState();
    // Add a listener to handle UI feedback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      authViewModel.addListener(_onAuthStateChanged);
    });
  }

  @override
  void dispose() {
    context.read<AuthViewModel>().removeListener(_onAuthStateChanged);
    _fullNameController.dispose();
    _emailController.dispose();
    _localityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.authState == AuthState.error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              authViewModel.errorMessage ?? 'An unknown error occurred.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      // Clear the error in the view model after showing it
      authViewModel.clearError();
    } else if (authViewModel.authState == AuthState.authenticated) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Sign up successful! Welcome.'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 24),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/sign-in'),
                ),
                const Expanded(
                  child: Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 40), // Spacer for alignment
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

                  // Title
                  const Text(
                    'Join the Mission',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connecting students, authors, and bookshops to end learning poverty.',
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
                        const Text(
                          'Full Name',
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
                            fillColor: const Color(0xFF161B17), // Field dark
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
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        const Text(
                          'University Email',
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
                            fillColor: const Color(0xFF161B17), // Field dark
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
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value!)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Locality
                        const Text(
                          'Locality / Neighborhood',
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
                            fillColor: const Color(0xFF161B17), // Field dark
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
                              return 'Locality is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        const Text(
                          'Password',
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
                            hintText: 'Min. 6 characters',
                            filled: true,
                            fillColor: const Color(0xFF161B17), // Field dark
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
                              return 'Password is required';
                            }
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
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
                                : const Text(
                                    'Sign Up',
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
                      const Text(
                        'PRICES ARE LISTED IN FCFA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A4D8C), // Scholar Blue
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In link
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/sign-in'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A4D8C), // Scholar Blue
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
