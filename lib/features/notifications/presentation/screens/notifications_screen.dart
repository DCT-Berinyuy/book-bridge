import 'package:book_bridge/features/notifications/presentation/viewmodels/notifications_viewmodel.dart';
import 'package:book_bridge/features/notifications/domain/entities/notification.dart'
    as entity;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Screen for displaying user notifications.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Force subscription when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsViewModel>().subscribeToNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications),
        centerTitle: true,
        actions: [
          Consumer<NotificationsViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.unreadCount > 0) {
                return IconButton(
                  icon: const Icon(Icons.done_all),
                  tooltip: AppLocalizations.of(context)!.markAllAsRead,
                  onPressed: () {
                    viewModel.markAllAsRead();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Text(
                AppLocalizations.of(
                  context,
                )!.errorWithDetails(viewModel.errorMessage!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          if (viewModel.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      size: 80,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.noNotificationsYet,
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.notificationsEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return _NotificationItem(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final entity.Notification notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = notification.isRead;

    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? Colors.transparent
            : theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isRead
              ? theme.disabledColor.withValues(alpha: 0.1)
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            _getIconForType(notification.type),
            color: isRead ? theme.disabledColor : theme.colorScheme.primary,
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead
                ? theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8)
                : null, // slight dim if read
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.body),
            const SizedBox(height: 4),
            Text(
              timeago.format(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
        onTap: () {
          if (!isRead) {
            context.read<NotificationsViewModel>().markAsRead(notification.id);
          }
          // Handle navigation if data present
          // final listingId = notification.data?['listing_id'];
          // if (listingId != null) context.push('/listing/$listingId');
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'listing':
        return Icons.menu_book;
      case 'message':
        return Icons.chat_bubble_outline;
      case 'security':
        return Icons.security;
      default:
        return Icons.notifications_none;
    }
  }
}
