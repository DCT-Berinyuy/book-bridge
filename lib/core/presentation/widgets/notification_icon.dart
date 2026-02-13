import 'package:book_bridge/features/notifications/presentation/viewmodels/notifications_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationIcon extends StatelessWidget {
  final Color? color;

  const NotificationIcon({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, viewModel, _) {
        final unreadCount = viewModel.unreadCount;

        return IconButton(
          icon: Badge(
            isLabelVisible: unreadCount > 0,
            label: Text(unreadCount.toString()),
            child: Icon(Icons.notifications_none_rounded, color: color),
          ),
          onPressed: () => context.push('/notifications'),
        );
      },
    );
  }
}
