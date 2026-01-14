// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeshare/data/models/event/event.dart';
import 'package:timeshare/data/models/event/event_recurrence.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:timeshare/providers/cal/cal_providers.dart';
import 'package:timeshare/services/logging/app_logger.dart';

final _logger = AppLogger();
const _tag = 'EditEventDialog';

/// Date representing "indefinite" recurrence (Jan 1, 2099)
final _indefiniteDate = DateTime(2099, 1, 1);

/// Dialog for editing an existing event
class EditEventDialog extends ConsumerStatefulWidget {
  final Event event;

  const EditEventDialog({
    super.key,
    required this.event,
  });

  @override
  ConsumerState<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends ConsumerState<EditEventDialog> {
  bool _canSubmit = false;
  late BoxShape _selectedShape;
  late Color _selectedColor;
  late EventRecurrence _selectedRecurrence;
  DateTime? _recurrenceEndDate;
  bool _repeatIndefinitely = false;

  late TextEditingController _eventNameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize from existing event
    _eventNameController = TextEditingController(text: widget.event.name);
    _selectedDate = normalizeDate(widget.event.time);
    _selectedTime = TimeOfDay.fromDateTime(widget.event.time);
    _selectedShape = widget.event.shape;
    _selectedColor = widget.event.color;
    _selectedRecurrence = widget.event.recurrence;
    _recurrenceEndDate = widget.event.recurrenceEndDate;

    // Check if it's set to indefinite
    if (_recurrenceEndDate != null &&
        _recurrenceEndDate!.year == 2099 &&
        _recurrenceEndDate!.month == 1 &&
        _recurrenceEndDate!.day == 1) {
      _repeatIndefinitely = true;
    }

    _dateController = TextEditingController(
      text: DateFormat.yMMMd().format(_selectedDate!),
    );
    _timeController = TextEditingController();

    // Initialize time controller after context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _timeController.text = _selectedTime!.format(context);
        _updateCanSubmit();
      }
    });
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _updateCanSubmit() {
    setState(() {
      _canSubmit =
          _selectedDate != null && _eventNameController.text.isNotEmpty;
    });
  }

  void _onSubmitted() {
    String selectedName = _eventNameController.text.trim();
    if (selectedName.isEmpty || _selectedDate == null) return;

    // Combine date and time
    DateTime eventDateTime = _selectedDate!;
    if (_selectedTime != null) {
      eventDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    // Determine end date
    DateTime? endDate;
    if (_selectedRecurrence != EventRecurrence.none) {
      if (_repeatIndefinitely) {
        endDate = _indefiniteDate;
      } else {
        endDate = _recurrenceEndDate;
      }
    }

    Event updatedEvent = widget.event.copyWith(
      name: selectedName,
      time: eventDateTime,
      color: _selectedColor,
      shape: _selectedShape,
      recurrence: _selectedRecurrence,
      recurrenceEndDate: endDate,
    );

    _logger.info('Updating event: ${updatedEvent.name}', tag: _tag);

    // Close dialog immediately (optimistic)
    Navigator.pop(context);

    // Fire mutation in background
    if (widget.event.calendarId != null) {
      _updateEventAsync(updatedEvent);
    }
  }

  Future<void> _updateEventAsync(Event updatedEvent) async {
    try {
      await ref
          .read(calendarMutationsProvider.notifier)
          .updateEventOptimistic(
            calendarId: widget.event.calendarId!,
            event: updatedEvent,
          );
    } catch (error) {
      if (mounted) {
        _logger.error('Failed to update event', error: error, tag: _tag);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update event: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _onDelete() {
    if (widget.event.calendarId == null) return;

    _logger.info('Deleting event: ${widget.event.name}', tag: _tag);

    // Close dialog immediately (optimistic)
    Navigator.pop(context);

    // Fire delete in background
    ref
        .read(calendarMutationsProvider.notifier)
        .deleteEventOptimistic(
          calendarId: widget.event.calendarId!,
          eventId: widget.event.id,
        )
        .then((result) {
      if (result.isFailure && mounted) {
        _logger.error('Failed to delete event', error: result.error, tag: _tag);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickRecurrenceEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recurrenceEndDate ??
          _selectedDate?.add(const Duration(days: 30)) ??
          DateTime.now().add(const Duration(days: 30)),
      firstDate: _selectedDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _recurrenceEndDate = normalizeDate(picked);
        _repeatIndefinitely = false;
      });
    }
  }

  String _colorToName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    return 'Green';
  }

  String _recurrenceToLabel(EventRecurrence recurrence) {
    switch (recurrence) {
      case EventRecurrence.none:
        return 'Does not repeat';
      case EventRecurrence.daily:
        return 'Daily';
      case EventRecurrence.weekly:
        return 'Weekly';
      case EventRecurrence.monthly:
        return 'Monthly';
      case EventRecurrence.yearly:
        return 'Yearly';
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarName = ref.watch(
      calendarNameProvider(widget.event.calendarId ?? ''),
    );

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
                      'Edit Event',
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
                    // Calendar name (read-only info)
                    Text(
                      'Calendar: $calendarName',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),

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

                    // Date and Time row
                    Row(
                      children: [
                        // Date picker field
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () => _pickDate(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Time picker field
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _timeController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onTap: () => _pickTime(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Recurrence dropdown
                    DropdownMenu<EventRecurrence>(
                      initialSelection: _selectedRecurrence,
                      expandedInsets: EdgeInsets.zero,
                      leadingIcon: const Icon(Icons.repeat),
                      label: const Text('Repeat'),
                      dropdownMenuEntries: EventRecurrence.values.map((recurrence) {
                        return DropdownMenuEntry(
                          value: recurrence,
                          label: _recurrenceToLabel(recurrence),
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          _selectedRecurrence = value ?? EventRecurrence.none;
                          if (_selectedRecurrence == EventRecurrence.none) {
                            _recurrenceEndDate = null;
                            _repeatIndefinitely = false;
                          }
                        });
                      },
                    ),

                    // Recurrence end date (only show if recurrence is set)
                    if (_selectedRecurrence != EventRecurrence.none) ...[
                      const SizedBox(height: 12),
                      // Repeat indefinitely checkbox
                      CheckboxListTile(
                        title: const Text('Repeat indefinitely'),
                        value: _repeatIndefinitely,
                        onChanged: (value) {
                          setState(() {
                            _repeatIndefinitely = value ?? false;
                            if (_repeatIndefinitely) {
                              _recurrenceEndDate = null;
                            }
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if (!_repeatIndefinitely) ...[
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _pickRecurrenceEndDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.event_busy),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _recurrenceEndDate != null
                                      ? DateFormat.yMMMd().format(_recurrenceEndDate!)
                                      : 'No end date',
                                  style: TextStyle(
                                    color: _recurrenceEndDate != null
                                        ? null
                                        : Theme.of(context).hintColor,
                                  ),
                                ),
                                if (_recurrenceEndDate != null)
                                  IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _recurrenceEndDate = null;
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 16),

                    // Shape selector
                    Text(
                      'Shape',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<BoxShape>(
                      segments: const [
                        ButtonSegment(
                          value: BoxShape.circle,
                          icon: Icon(Icons.circle_outlined),
                          label: Text('Circle'),
                        ),
                        ButtonSegment(
                          value: BoxShape.rectangle,
                          icon: Icon(Icons.square_outlined),
                          label: Text('Square'),
                        ),
                      ],
                      selected: {_selectedShape},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _selectedShape = selected.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Color selector
                    Text(
                      'Color',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
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
                children: [
                  // Delete button on the left
                  TextButton.icon(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const Spacer(),
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
                        Icon(Icons.save, size: 20),
                        SizedBox(width: 4),
                        Text('Save'),
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
