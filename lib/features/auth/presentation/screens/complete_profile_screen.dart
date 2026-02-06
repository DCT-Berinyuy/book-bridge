import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';

/// Screen for Google users to provide missing profile information.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _localityController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load profile data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  void dispose() {
    _localityController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false, // User must complete profile
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthViewModel>().signOut(),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Just one more step!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'To start buying and selling, we need a few more details to help other students find you.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Locality
                  const Text(
                    'Locality / Neighborhood',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _localityController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Molyko, Buea',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Locality is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // WhatsApp
                  const Text(
                    'WhatsApp Number',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _whatsappController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. 677...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Number is required';
                      if (!RegExp(r'^\d{9}$').hasMatch(value!)) {
                        return 'Enter a valid 9-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: profileViewModel.isLoading
                          ? null
                          : () async {
                              debugPrint(
                                'CompleteProfileScreen: "Complete Setup" clicked.',
                              );
                              if (_formKey.currentState?.validate() ?? false) {
                                debugPrint(
                                  'CompleteProfileScreen: Form validated.',
                                );
                                final authViewModel = context
                                    .read<AuthViewModel>();
                                final user = authViewModel.currentUser;
                                debugPrint(
                                  'CompleteProfileScreen: Current User: ${user?.id}',
                                );
                                if (user != null) {
                                  final messenger = ScaffoldMessenger.of(
                                    context,
                                  );
                                  await profileViewModel.updateUser(
                                    fullName: user.fullName,
                                    locality: _localityController.text.trim(),
                                    whatsappNumber: _whatsappController.text
                                        .trim(),
                                  );

                                  if (profileViewModel.profileState ==
                                      ProfileState.error) {
                                    debugPrint(
                                      'CompleteProfileScreen: Update error: ${profileViewModel.errorMessage}',
                                    );
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            profileViewModel.errorMessage ??
                                                'Failed to update profile',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } else {
                                    debugPrint(
                                      'CompleteProfileScreen: Update successful, refreshing Auth user...',
                                    );
                                    await authViewModel.refreshUser();
                                  }
                                } else {
                                  debugPrint(
                                    'CompleteProfileScreen: Error - User is null.',
                                  );
                                }
                              } else {
                                debugPrint(
                                  'CompleteProfileScreen: Form validation failed.',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4D8C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: profileViewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Complete Setup',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
