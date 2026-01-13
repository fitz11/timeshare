// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/user/app_user.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/providers/user/user_providers.dart';
import 'package:timeshare/ui/core/responsive/responsive.dart';
import 'package:timeshare/ui/features/profile/widgets/profile_dialogs.dart';
import 'package:timeshare/ui/features/profile/widgets/stat_card.dart';
import 'package:timeshare/utils/error_utils.dart';
import 'package:timeshare/utils/string_utils.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return _buildErrorState(context, 'No user data available');
        }
        return _buildProfileContent(context, ref, user);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(context, formatError(error)),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
  ) {
    final initials = getInitials(user.displayName);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final calendarsAsync = ref.watch(calendarsProvider);

    // Calculate member duration
    final memberDuration = DateTime.now().difference(user.joinedAt);
    final memberDays = memberDuration.inDays;
    String memberSince;
    if (memberDays < 1) {
      memberSince = 'Today';
    } else if (memberDays == 1) {
      memberSince = '1 day';
    } else if (memberDays < 30) {
      memberSince = '$memberDays days';
    } else if (memberDays < 365) {
      final months = (memberDays / 30).floor();
      memberSince = '$months month${months > 1 ? 's' : ''}';
    } else {
      final years = (memberDays / 365).floor();
      memberSince = '$years year${years > 1 ? 's' : ''}';
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentUserProvider);
        ref.invalidate(calendarsProvider);
      },
      child: ConstrainedContent(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          const SizedBox(height: 16),

          // Profile Header Card with status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                        child: user.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.photoUrl!,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Text(
                                    initials.isEmpty ? '?' : initials,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                initials.isEmpty ? '?' : initials,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      // Online status indicator
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Display Name
                  Text(
                    user.displayName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Active status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active now',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.people_outline,
                  label: 'Friends',
                  value: '${user.friends.length}',
                  onTap: () {
                    ref
                        .read(navIndexProvider.notifier)
                        .update(HomePages.friends);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: calendarsAsync.when(
                  data: (calendars) {
                    final ownedCount =
                        calendars.where((c) => c.owner == user.uid).length;
                    final sharedCount = calendars.length - ownedCount;
                    return StatCard(
                      icon: Icons.calendar_month_outlined,
                      label: 'Calendars',
                      value: '${calendars.length}',
                      subtitle: '$ownedCount owned, $sharedCount shared',
                      onTap: () {
                        ref
                            .read(navIndexProvider.notifier)
                            .update(HomePages.calendar);
                      },
                    );
                  },
                  loading: () => StatCard(
                    icon: Icons.calendar_month_outlined,
                    label: 'Calendars',
                    value: '...',
                  ),
                  error: (_, _) => StatCard(
                    icon: Icons.calendar_month_outlined,
                    label: 'Calendars',
                    value: '-',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  icon: Icons.schedule_outlined,
                  label: 'Member',
                  value: memberSince,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account Information Card
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Account',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Display Name Section
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Display Name'),
                  subtitle: Text(user.displayName),
                  trailing: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  onTap: () => showEditDisplayNameDialog(context, ref, user),
                ),

                const Divider(height: 1, indent: 56),

                // Email Section
                ListTile(
                  leading: Icon(
                    Icons.email_outlined,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                  trailing: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  onTap: () => showChangeEmailDialog(context, ref, user),
                ),

                const Divider(height: 1, indent: 56),

                // Password Section
                ListTile(
                  leading: Icon(
                    Icons.lock_outline,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Password'),
                  subtitle: const Text('Change your password'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.outline,
                  ),
                  onTap: () => showChangePasswordDialog(context, ref, user),
                ),

                const Divider(height: 1, indent: 56),

                // Joined Date
                ListTile(
                  leading: Icon(
                    Icons.cake_outlined,
                    color: colorScheme.outline,
                  ),
                  title: const Text('Joined'),
                  subtitle: Text(DateFormat.yMMMMd().format(user.joinedAt)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legal & Support Card
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Legal & Support',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),

                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.outline,
                  ),
                  onTap: () => showPrivacyPolicyDialog(context),
                ),

                const Divider(height: 1, indent: 56),

                ListTile(
                  leading: Icon(
                    Icons.security_outlined,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Security Information'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.outline,
                  ),
                  onTap: () => showSecurityInfoDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          Card(
            color: colorScheme.errorContainer,
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: colorScheme.onErrorContainer,
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colorScheme.onErrorContainer.withValues(alpha: 0.7),
              ),
              onTap: () => showLogoutDialog(context, ref),
            ),
          ),

          const SizedBox(height: 32),
        ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
