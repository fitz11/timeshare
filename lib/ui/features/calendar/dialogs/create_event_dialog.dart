// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';

/// Dialog for creating a new event
class CreateEventDialog extends ConsumerStatefulWidget {
  final String calendarId;
  final String calendarName;

  const CreateEventDialog({
    super.key,
    required this.calendarId,
    required this.calendarName,
  });

  @override
  ConsumerState<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends ConsumerState<CreateEventDialog> {
  bool _canSubmit = false;
  bool _makeSquare = false;
  Color _selectedColor = Colors.black;

  late TextEditingController _eventNameController;
  late TextEditingController _dateController;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController();
    _selectedDate = normalizeDate(DateTime.now());
    _dateController = TextEditingController(
      text: DateFormat.yMMMd().format(normalizeDate(_selectedDate!)),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _updateCanSubmit() {
    setState(() {
      _canSubmit =
          _selectedDate != null && _eventNameController.text.isNotEmpty;
    });
  }

  Future<void> _onSubmitted() async {
    String selectedName = _eventNameController.text.trim();
    if (selectedName.isEmpty || _selectedDate == null) return;

    BoxShape shape = _makeSquare ? BoxShape.rectangle : BoxShape.circle;
    Event newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: selectedName,
      time: _selectedDate!,
      color: _selectedColor,
      shape: shape,
    );

    await ref
        .read(calendarMutationsProvider.notifier)
        .addEvent(calendarId: widget.calendarId, event: newEvent);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event "$selectedName" added successfully')),
      );
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = normalizeDate(picked);
        _dateController.text = DateFormat.yMMMd().format(_selectedDate!);
        _updateCanSubmit();
      });
    }
  }

  String _colorToName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    return 'Green';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Event to ${widget.calendarName}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Event name field
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                      controller: _eventNameController,
                      onChanged: (_) => _updateCanSubmit(),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),

                    // Date picker field
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(context),
                    ),
                    const SizedBox(height: 16),

                    // Shape checkbox
                    CheckboxListTile(
                      title: const Text('Square shape'),
                      subtitle: const Text('Use square instead of circle'),
                      value: _makeSquare,
                      onChanged: (val) {
                        setState(() {
                          _makeSquare = val ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 8),

                    // Color selector
                    Text(
                      'Color',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children:
                          [
                            Colors.black,
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                          ].map((color) {
                            final isSelected = _selectedColor == color;
                            return ChoiceChip(
                              label: Text(_colorToName(color)),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedColor = color;
                                  });
                                }
                              },
                              avatar: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _canSubmit ? _onSubmitted : null,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 4),
                        Text('Add Event'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
