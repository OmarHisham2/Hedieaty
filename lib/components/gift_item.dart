import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data_models/gift.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class GiftItem extends StatelessWidget {
  GiftItem({super.key, required this.giftDetails});

  Gift giftDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white),
          ),
          width: double.infinity,
          height: 150,
          child: Row(
            children: [
              addHorizontalSpace(10),
              Image.network(
                giftDetails.imageUrl,
                width: 100,
                height: 120,
              ),
              addHorizontalSpace(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    giftDetails.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${giftDetails.price.toString()}'),
                  Text(
                      'Category: ${giftDetails.giftCategory.name[0].toUpperCase() + giftDetails.giftCategory.name.substring(1)}'),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
              addHorizontalSpace(20)
            ],
          ),
        ),
      ),
    );
  }
}
