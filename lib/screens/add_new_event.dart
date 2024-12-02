import 'package:flutter/material.dart';
import 'package:hedieaty2/components/gift_item.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/data_models/gift.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final String _eventName = '';
  Category _selectedCategory = Category.birthday;
  final _selectedDate = '';
  final List<Gift> giftList = [];

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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.transparent),
                      ),
                      child: DropdownButtonFormField(
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
                        onPressed: () async {
                          var giftData = await Navigator.pushNamed<dynamic>(
                            context,
                            '/addgift',
                          );
                          if (giftData != null) {
                            setState(() {
                              giftList.add(giftData);
                            });
                          }
                        },
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...giftList.map((gift) => GiftItem(
                            giftDetails: gift,
                          ))
                    ],
                  ),
                ),
              ),
              addVerticalSpace(20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add New Event'),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(203, 83, 81, 81),
                ),
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
