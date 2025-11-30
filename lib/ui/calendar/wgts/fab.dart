// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeshare/data/enums.dart';
import 'package:timeshare/data/models/calendar/calendar.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/providers/nav/nav_providers.dart';
import 'package:timeshare/ui/dialogs/create_calendar_dialog.dart';
import 'package:timeshare/ui/dialogs/open_eventbuilder_dialog.dart';

class Fab extends ConsumerStatefulWidget {
  const Fab({super.key});

  @override
  ConsumerState<Fab> createState() => _FabState();
}

class _FabState extends ConsumerState<Fab> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _close() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(navIndexProvider);

    // Only show FAB on calendar page
    if (page != HomePages.calendar) {
      return const SizedBox.shrink();
    }

    final calendars = ref.watch(calendarsProvider);

    return calendars.when(
      data: (calendarsList) => _buildSpeedDial(context, calendarsList),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildSpeedDial(BuildContext context, List<Calendar> calendars) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Add Calendar option
        if (_isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildSpeedDialItem(
                context,
                icon: Icons.calendar_month,
                label: 'New Calendar',
                onTap: () {
                  _close();
                  showCreateCalendarDialog(context, ref);
                },
              ),
            ),
          ),

        // Add Event option
        if (_isOpen)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildSpeedDialItem(
                context,
                icon: Icons.event,
                label: 'New Event',
                onTap: () {
                  _close();
                  openEventBuilder(context, calendars);
                },
              ),
            ),
          ),

        // Main FAB button
        RotationTransition(
          turns: _rotationAnimation,
          child: FloatingActionButton(
            onPressed: _toggle,
            child: Icon(_isOpen ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: null, // Important: prevent hero animation conflicts
            mini: true,
            onPressed: onTap,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }
}
