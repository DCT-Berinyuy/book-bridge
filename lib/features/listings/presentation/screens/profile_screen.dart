import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/profile_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/edit-profile');
              } else if (value == 'help') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon!')),
                );
              } else if (value == 'logout') {
                _confirmLogout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20, color: Colors.black87),
                    SizedBox(width: 12),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20, color: Colors.black87),
                    SizedBox(width: 12),
                    Text('Help & Support'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
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
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'My Profile Edit',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.favorite_border,
                    title: 'My Favourites',
                    onTap: () => context.push('/favorites'),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.book_outlined,
                    title: 'My Books',
                    onTap: () => context.go('/my-books'),
                    isLast: true,
                  ),
                ]),
                const Divider(height: 1),
                _buildMenuSection(context, 'More', [
                  _buildMenuItem(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Privacy Policy',
                    onTap: () => context.push('/privacy'),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => context.push('/terms'),
                  ),
                  _buildExpandableMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.help_outline,
                        title: 'FAQ',
                        onTap: () => context.push('/faq'),
                        indent: true,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.feedback_outlined,
                        title: 'Feedback',
                        onTap: () => context.push('/feedback'),
                        indent: true,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.email_outlined,
                        title: 'Contact Us',
                        onTap: () => context.push('/contact'),
                        indent: true,
                        isLast: true,
                      ),
                    ],
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.share_outlined,
                    title: 'Invite friends',
                    onTap: () {
                      Share.share(
                        'Join me on BookBridge, the peer-to-peer marketplace for used books in Cameroon! 📚✨\n\nDownload or visit us at: https://book-bridge-three.vercel.app/',
                        subject: 'Invite to BookBridge',
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About BookBridge',
                    onTap: () => context.push('/about'),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () => _confirmLogout(context),
                    isLast: true,
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
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
              letterSpacing: 1.1,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    bool isLast = false,
    bool indent = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 22,
            color: textColor ?? Colors.black87.withValues(alpha: 0.8),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: textColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
          trailing: Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.grey.withValues(alpha: 0.6),
          ),
          contentPadding: EdgeInsets.only(left: indent ? 40 : 20, right: 20),
          visualDensity: VisualDensity.compact,
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.only(left: indent ? 80 : 60),
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
      ],
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(
              icon,
              size: 22,
              color: Colors.black87.withValues(alpha: 0.8),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              Icons.expand_more,
              size: 18,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            childrenPadding: EdgeInsets.zero,
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
            children: children,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
        ),
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
              _buildSocialIcon(
                FontAwesomeIcons.facebook,
                const Color(0xFF1877F2),
                'Facebook',
                () => _launchUrl(
                  'https://www.facebook.com/profile.php?id=61572639047021',
                ),
              ),
              _buildSocialIcon(
                FontAwesomeIcons.instagram,
                const Color(0xFFE4405F),
                'Instagram',
                () =>
                    _launchUrl('https://www.instagram.com/verlaberinyuyndey/'),
              ),
              _buildSocialIcon(
                FontAwesomeIcons.youtube,
                const Color(0xFFFF0000),
                'YouTube',
                () => _launchUrl('https://www.youtube.com/@VerlaBerinyuy'),
              ),
              _buildSocialIcon(
                FontAwesomeIcons.linkedinIn,
                const Color(0xFF0A66C2),
                'LinkedIn',
                () => _launchUrl(
                  'https://www.linkedin.com/in/verla-berinyuy-15b1262a5/',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: FaIcon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
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
