import 'dart:ui';

import 'package:hedieaty2/data_models/event.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum GiftStatus { available, pledged }

enum GiftCategory { electronics, books }

class Gift {
  final String name;
  final String description;
  final Event associatedEvent;
  final Image image;
  final GiftCategory giftCategory;
  final Category eventCategory;
  final GiftStatus giftStatus;
  final String id;

  Gift({
    required this.name,
    required this.description,
    required this.associatedEvent,
    required this.image,
    required this.giftCategory,
    required this.giftStatus,
  })  : id = uuid.v4(),
        eventCategory = associatedEvent.category;
}
