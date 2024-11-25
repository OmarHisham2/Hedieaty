import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/data_models/gift.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class AddNewGift extends StatelessWidget {
  String _giftName = '';
  GiftCategory _giftCategory = GiftCategory.books;
  double _giftPrice = 0;
  String _giftURL = '';
  String _giftDescription = '';

  final _formKey = GlobalKey<FormState>();

  AddNewGift({super.key});

  Gift _submitResponse() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      return Gift(
        name: _giftName,
        price: _giftPrice,
        description: _giftDescription,
        imageUrl: _giftURL,
        giftCategory: _giftCategory,
      );
    } else {
      return Gift(
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
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Gift myGift = _submitResponse();
                  Navigator.of(context).pop(myGift);
                },
                child: const Text('Add New Gift'),
              ),
              addVerticalSpace(15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(144, 163, 58, 58)
                          : const Color.fromARGB(144, 230, 61, 58),
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
