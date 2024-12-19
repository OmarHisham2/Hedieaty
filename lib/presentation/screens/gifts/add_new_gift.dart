import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/data/repositories/firebase_service.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/domain/usecases/add_gift.dart';

class AddNewGift extends StatelessWidget {
  String _giftName = '';
  GiftCategory _giftCategory = GiftCategory.books;
  double _giftPrice = 0;
  String _giftURL = '';
  String _giftDescription = '';

  final String _giftID = uuid.v4();
  final String eventID;
  final bool isPublished;

  final _formKey = GlobalKey<FormState>();

  final AddGift _addGift = AddGift(GiftsDB());

  AddNewGift({super.key, required this.eventID, required this.isPublished});

  Gift _addNewGift() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      return Gift(
          id: _giftID,
          name: _giftName,
          price: _giftPrice,
          description: _giftDescription,
          imageUrl: _giftURL,
          giftCategory: _giftCategory,
          giftStatus: GiftStatus.available,
          pledgerID: '');
    } else {
      return Gift(
          id: 'null',
          name: 'null',
          description: 'null',
          price: 0,
          imageUrl: 'null',
          giftCategory: GiftCategory.books);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Add New Gift',
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
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                onSaved: (value) {
                  _giftName = value!;
                },
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
                        hint: Text(
                          'Select Category',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          _giftCategory = value!;
                        },
                        items: GiftCategory.values
                            .map((GiftCategory giftCategory) {
                          return DropdownMenuItem<GiftCategory>(
                            value: giftCategory,
                            child: Text(
                                style: Theme.of(context).textTheme.labelSmall,
                                '${giftCategory.name[0].toUpperCase()}${giftCategory.name.substring(1)}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  addHorizontalSpace(25),
                  Expanded(
                    child: TextFormField(
                      onSaved: (value) {
                        _giftPrice = double.tryParse(value!)!;
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(20),
              TextFormField(
                onSaved: (value) {
                  _giftURL = value!;
                },
                decoration: const InputDecoration(
                  label: Text('Image Url'),
                ),
              ),
              addVerticalSpace(20),
              SizedBox(
                height: 150,
                child: TextFormField(
                  onSaved: (value) {
                    _giftDescription = value!;
                  },
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              addVerticalSpace(40),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  await _addGift(
                    id: _giftID,
                    name: _giftName,
                    description: _giftDescription,
                    category: _giftCategory.toString(),
                    price: _giftPrice,
                    status: "Available",
                    eventID: eventID,
                    image: _giftURL,
                  );

                  Navigator.pop(context, true);
                },
                child: const Text('Add New Gift'),
              ),
              addVerticalSpace(25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(203, 83, 81, 81),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              addVerticalSpace(150),
            ],
          ),
        ),
      ),
    );
  }
}
