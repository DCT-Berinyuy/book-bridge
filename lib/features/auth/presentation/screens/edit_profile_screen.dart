import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _localityController;
  late TextEditingController _whatsappController;

  // Save reference to avoid accessing context in dispose()
  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    super.initState();
    _profileViewModel = context.read<ProfileViewModel>();
    _fullNameController = TextEditingController(
      text: _profileViewModel.currentUser?.fullName ?? '',
    );
    _localityController = TextEditingController(
      text: _profileViewModel.currentUser?.locality ?? '',
    );
    _whatsappController = TextEditingController(
      text: _profileViewModel.currentUser?.whatsappNumber ?? '',
    );

    // Add a listener to handle UI feedback after profile update
    _profileViewModel.addListener(_onProfileStateChanged);
  }

  @override
  void dispose() {
    // Remove the listener before disposing using saved reference
    _profileViewModel.removeListener(_onProfileStateChanged);
    _fullNameController.dispose();
    _localityController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _onProfileStateChanged() {
    // Check if the widget is still mounted before accessing context
    if (!mounted) return;

    final profileViewModel = context.read<ProfileViewModel>();
    if (profileViewModel.profileState == ProfileState.error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              profileViewModel.errorMessage ?? 'Failed to update profile.',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    } else if (profileViewModel.profileState == ProfileState.loaded) {
      // Assuming successful update means we are in loaded state
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      // Navigate back after a short delay to ensure UI updates
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Check again if still mounted before navigating
          context.pop(); // Navigate back after successful update
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    enabled: !profileViewModel.isLoading,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _localityController,
                    enabled: !profileViewModel.isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Locality / Neighborhood',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _whatsappController,
                    enabled: !profileViewModel.isLoading,
                    decoration: const InputDecoration(
                      labelText: 'WhatsApp Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: profileViewModel.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              profileViewModel.updateUser(
                                fullName: _fullNameController.text.trim(),
                                locality: _localityController.text.trim(),
                                whatsappNumber: _whatsappController.text.trim(),
                              );
                            }
                          },
                    child: profileViewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Changes'),
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
