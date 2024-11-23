import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class AddNewEvent extends StatelessWidget {
  AddNewEvent({super.key});

  final String _eventName = '';
  Category _selectedCategory = Category.birthday;
  final _selectedDate = '';

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Event Name'),
                ),
              ),
              addVerticalSpace(20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      onChanged: (value) {
                        _selectedCategory = value!;
                      },
                      items: Category.values.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                              '${category.name[0].toUpperCase()}${category.name.substring(1)}'),
                        );
                      }).toList(),
                    ),
                  ),
                  addHorizontalSpace(25),
                  Expanded(
                    child: InputDatePickerFormField(
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2001),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(20),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Gift List',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 25),
                      ),
                      addHorizontalSpace(15),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                      )
                    ],
                  ),
                ],
              ),
              addVerticalSpace(5),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              addVerticalSpace(20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add New Event'),
              ),
              addVerticalSpace(15),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
