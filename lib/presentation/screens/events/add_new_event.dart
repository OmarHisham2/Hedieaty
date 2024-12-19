import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/data/repositories/firebase_service.dart';
import 'package:hedieaty2/domain/usecases/add_event.dart';
import 'package:hedieaty2/presentation/widgets/CheckboxFormField.dart';
import 'package:hedieaty2/services/auth/auth.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final _formKey = GlobalKey<FormState>();
  String _eventName = '';
  Category _selectedCategory = Category.birthday;
  DateTime? _selectedDate;
  String _location = '';
  String _description = '';
  bool _isPublished = false;
  final AddEvent _addEvent = AddEvent(EventsDB());
  final _rlService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Add New Event',
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
                decoration: const InputDecoration(label: Text('Event Name')),
                onSaved: (value) => _eventName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Event name is required' : null,
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
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          label: Text('Event Category'),
                        ),
                        onChanged: (value) {
                          _selectedCategory = value!;
                        },
                        items: Category.values.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                                style: Theme.of(context).textTheme.labelSmall,
                                '${category.name[0].toUpperCase()}${category.name.substring(1)}'),
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
                      initialDate: DateTime.now(),
                      onDateSaved: (value) {
                        _selectedDate = value;
                      },
                    ),
                  ),
                ],
              ),
              addVerticalSpace(20),
              TextFormField(
                decoration: const InputDecoration(label: Text('Location')),
                onSaved: (value) => _location = value!,
              ),
              addVerticalSpace(20),
              TextFormField(
                decoration: const InputDecoration(label: Text('Description')),
                onSaved: (value) => _description = value!,
              ),
              addVerticalSpace(20),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: CheckboxFormField(
                  onSaved: (value) {
                    _isPublished = value!;
                  },
                  title: Text(
                    'Publish Event? ',
                    style: GoogleFonts.poppins(
                        color: isDark ? Colors.white : const Color(0xff5a5a58),
                        fontSize: 20.0),
                  ),
                ),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    String eventID = uuid.v4();
                    await _addEvent(
                        id: eventID,
                        name: _eventName,
                        date: _selectedDate!,
                        location: _location,
                        description: _description,
                        userID: Auth().currentUser!.uid,
                        category: _selectedCategory,
                        isPublished: _isPublished);

                    if (_isPublished) {
                      _rlService.rlCreateEvent(Event(
                        name: _eventName,
                        date: _selectedDate!,
                        location: _location,
                        description: _description,
                        userID: Auth().currentUser!.uid,
                        category: _selectedCategory,
                        id: eventID,
                        status: Status.Current,
                        giftList: [],
                      ));
                    }

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        showCloseIcon: false,
                        behavior: SnackBarBehavior.floating,
                        content: AwesomeSnackbarContent(
                          title: 'Event Created!',
                          message:
                              'You have successfully created an event.\n Start Adding Gifts!',
                          contentType: ContentType.success,
                        ),
                      ));

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add New Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
