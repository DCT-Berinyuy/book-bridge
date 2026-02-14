import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';
import 'package:intl/intl.dart';

/// User profile screen displaying user information and their listings.
///
/// This screen shows the current user's profile information, their active listings,
/// and provides options to manage or delete listings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileViewModel>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4D8C),
        foregroundColor: Colors.white,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, _) {
          if (profileViewModel.profileState == ProfileState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = profileViewModel.currentUser;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user),
                _buildStatsSection(context, profileViewModel),
                const Divider(height: 1),
                _buildMenuSection(context, 'My Account', [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'My Profile',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _MenuItem(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Favourites',
                    onTap: () {
                      // Future: My Favourites
                    },
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'My Location Update',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _MenuItem(
                    icon: Icons.library_books_outlined,
                    title: 'My Books',
                    onTap: () => context.go('/my-books'),
                  ),
                ]),
                const Divider(height: 1),
                _buildMenuSection(context, 'More', [
                  _MenuItem(
                    icon: Icons.lock_outline,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.feedback_outlined,
                    title: 'Feedback',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.email_outlined,
                    title: 'Contact Us',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.share_outlined,
                    title: 'Invite friends',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () => _confirmLogout(context),
                  ),
                ]),
                _buildFollowUs(context),
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4D8C).withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF1A4D8C),
            backgroundImage:
                user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                ? Text(
                    user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : user.email[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName.isNotEmpty ? user.fullName : user.email,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                user.locality ?? 'Unknown Location',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, ProfileViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              vm.userListings.length.toString(),
              'Active Books',
              const Color(0xFF1A4D8C),
            ),
          ),
          Container(height: 40, width: 1, color: Colors.grey[300]),
          Expanded(
            child: _buildStatItem(
              context,
              '${NumberFormat.compact().format(vm.userListings.fold<int>(0, (sum, item) => sum + item.priceFcfa))} FCFA',
              'Total Value',
              const Color(0xFF27AE60),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<_MenuItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...items.map(
          (item) => Column(
            children: [
              ListTile(
                leading: Icon(item.icon, size: 24, color: Colors.black87),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: item.textColor ?? Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: item.onTap,
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              if (items.indexOf(item) != items.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Divider(height: 1, color: Colors.grey[200]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFollowUs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow Us',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon(Icons.facebook, Colors.blue),
              _buildSocialIcon(Icons.camera_alt, Colors.pink),
              _buildSocialIcon(Icons.play_circle_fill, Colors.red),
              _buildSocialIcon(Icons.close, Colors.black),
              _buildSocialIcon(Icons.language, Colors.blueGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthViewModel>().signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });
}
