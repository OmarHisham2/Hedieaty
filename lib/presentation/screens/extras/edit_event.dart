import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({super.key, required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String _eventName = '';
  Category? _selectedCategory;
  DateTime? _selectedDate;
  String _location = '';
  String _description = '';
  bool _isPublished = false;

  final EventsDB _eventsDB = EventsDB();

  @override
  void initState() {
    super.initState();

    _eventName = widget.event.name;
    _selectedCategory = widget.event.category;
    _selectedDate = widget.event.date;
    _location = widget.event.location;
    _description = widget.event.description;
    _isPublished = widget.event.isPublished;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Status getStatus() {
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime eventDate =
        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (eventDate.isAtSameMomentAs(todayDate)) {
      return Status.Current;
    } else if (eventDate.isBefore(todayDate)) {
      return Status.Past;
    } else {
      return Status.Upcoming;
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      await _eventsDB.updateEvent(
          id: widget.event.id,
          name: _eventName,
          description: _description,
          location: _location,
          category: _selectedCategory!,
          date: _selectedDate!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event updated successfully!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Event',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _eventName,
                decoration: const InputDecoration(label: Text('Event Name')),
                validator: (value) =>
                    value!.isEmpty ? 'Event name is required' : null,
                onSaved: (value) => _eventName = value!,
                maxLength: 15,
              ),
              addVerticalSpace(20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: DropdownButtonFormField<Category>(
                        decoration: const InputDecoration(
                          label: Text(
                            'Event Category',
                          ),
                        ),
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        items: Category.values.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                              style: const TextStyle(fontSize: 15),
                              '${category.name[0].toUpperCase()}${category.name.substring(1)}',
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  addHorizontalSpace(25),
                  Expanded(
                    child: InputDatePickerFormField(
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: _selectedDate,
                      onDateSaved: (value) {
                        _selectedDate = value;
                      },
                    ),
                  ),
                ],
              ),
              addVerticalSpace(20),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(label: Text('Location')),
                onSaved: (value) => _location = value!,
              ),
              addVerticalSpace(20),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(label: Text('Description')),
                maxLines: 3,
                onSaved: (value) => _description = value!,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                key: const ValueKey('edit_event_button'),
                onPressed: _saveEvent,
                child: const Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
