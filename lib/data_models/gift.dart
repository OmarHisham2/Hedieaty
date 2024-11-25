import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum GiftStatus { available, pledged }

enum GiftCategory { electronics, books }

class Gift {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final GiftCategory giftCategory;
  final GiftStatus giftStatus;
  final String id;

  Gift({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.giftCategory,
  })  : id = uuid.v4(),
        giftStatus = GiftStatus.available;
}
