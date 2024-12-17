import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class GiftItemListed extends StatelessWidget {
  GiftItemListed({super.key, required this.giftDetails});

  Gift giftDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          width: double.infinity,
          height: 100,
          child: Column(
            children: [
              Row(
                children: [
                  addHorizontalSpace(10),
                  CachedNetworkImage(
                    imageUrl: giftDetails.imageUrl!,
                    placeholder: (context, url) => Container(
                      color: Colors.transparent,
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/imageFailed.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  addHorizontalSpace(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            giftDetails.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          addHorizontalSpace(20),
                          Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  giftDetails.giftStatus == GiftStatus.available
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                            ),
                            child: SizedBox(),
                          ),
                        ],
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
                  addHorizontalSpace(20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
