import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/repositories/events_db.dart';
import 'package:hedieaty2/data/repositories/firebase_service.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/domain/usecases/add_gift.dart';

class AddNewGift extends StatefulWidget {
  final String eventID;
  final bool isPublished;

  const AddNewGift(
      {super.key, required this.eventID, required this.isPublished});

  @override
  State<AddNewGift> createState() => _AddNewGiftState();
}

class _AddNewGiftState extends State<AddNewGift> {
  String _giftName = '';

  GiftCategory _giftCategory = GiftCategory.na;

  double _giftPrice = 0;

  String _giftURL = '';

  String _giftDescription = '';

  final String _giftID = uuid.v4();

  final _formKey = GlobalKey<FormState>();

  final AddGift _addGift = AddGift(GiftsDB());

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
          giftCategory: _giftCategory);
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
                key: const ValueKey('gift_name_field'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name for the gift.';
                  }
                  return null;
                },
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
                      child: FormField<GiftCategory>(
                        initialValue: _giftCategory,
                        builder: (FormFieldState<GiftCategory> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              errorText:
                                  state.hasError ? state.errorText : null,
                              labelText: 'Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<GiftCategory>(
                                value: state.value,
                                isDense: true,
                                onChanged: (GiftCategory? newValue) {
                                  state.didChange(newValue);
                                  _giftCategory = newValue!;
                                },
                                items: GiftCategory.values
                                    .map((GiftCategory giftCategory) {
                                  return DropdownMenuItem<GiftCategory>(
                                    value: giftCategory,
                                    child: Text(
                                      '${giftCategory.name[0].toUpperCase()}${giftCategory.name.substring(1)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  addHorizontalSpace(25),
                  Expanded(
                    child: TextFormField(
                      key: const ValueKey('gift_price_field'),
                      onSaved: (value) {
                        _giftPrice = double.tryParse(value!)!;
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a price.';
                        }
                        final parsedValue = double.tryParse(value);
                        if (parsedValue == null || parsedValue <= 0) {
                          return 'Please enter a valid positive number.';
                        }
                        return null;
                      },
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
                key: const ValueKey('gift_save_button'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _addGift(
                      id: _giftID,
                      name: _giftName,
                      description: _giftDescription,
                      category: _giftCategory.toString(),
                      price: _giftPrice,
                      status: "Available",
                      eventID: widget.eventID,
                      image: _giftURL,
                    );

                    Navigator.pop(context, true);
                  }
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
