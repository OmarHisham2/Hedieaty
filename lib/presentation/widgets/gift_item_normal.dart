import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/gift.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/data/repositories/gifts_db.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:holdable_button/holdable_button.dart';
import 'package:holdable_button/utils/utils.dart';

class GiftItemNormal extends StatelessWidget {
  GiftItemNormal(
      {super.key,
      required this.giftDetails,
      required this.onPledge,
      required this.isPledged});

  Gift giftDetails;
  VoidCallback onPledge;
  bool isPledged;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          width: double.infinity,
          height: 120,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        ],
                      ),
                      Text('\$${giftDetails.price.toString()}'),
                      Text(
                          'Category: ${giftDetails.giftCategory.name[0].toUpperCase() + giftDetails.giftCategory.name.substring(1)}'),
                    ],
                  ),
                  const Spacer(),
                  isPledged
                      ? OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                showCloseIcon: false,
                                behavior: SnackBarBehavior.floating,
                                content: AwesomeSnackbarContent(
                                  title: 'Gift Already Pledged!',
                                  message: 'Try pledging another gift.',
                                  contentType: ContentType.failure,
                                ),
                              ));
                          },
                          child: Text(
                            'Pledged',
                            style: TextStyle(
                                color: !isDark
                                    ? const Color.fromARGB(255, 92, 86, 86)
                                    : const Color.fromARGB(255, 219, 216, 216),
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : HoldableButton(
                          loadingType: LoadingType.edgeLoading,
                          buttonColor: Colors.transparent,
                          loadingColor: Colors.red,
                          duration: 4,
                          radius: 20,
                          onConfirm: onPledge,
                          strokeWidth: 5,
                          width: 80,
                          height: 40,
                          child: OutlinedButton(
                            child: Text(
                              'Pledge',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                            onPressed: () {},
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
