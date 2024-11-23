import 'package:flutter/material.dart';
// Boxes

const COLOR_BOX_BACKGROUND_LIGHT = Color.fromARGB(148, 159, 157, 154);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 34, 32, 32);

class GoodCard extends StatelessWidget {
  final String text;

  final String subText;

  final Function onClick;

  const GoodCard(
      {required this.text,
      required this.subText,
      super.key,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: isDark ? COLOR_BOX_BACKGROUND_DARK : COLOR_BOX_BACKGROUND_LIGHT,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: InkWell(
        onTap: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(text, style: textTheme.labelLarge),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Color.fromARGB(255, 53, 52, 50),
                  )
                ],
              ),
              const Spacer(),
              Text(
                  textAlign: TextAlign.start,
                  subText,
                  style: textTheme.labelMedium)
            ],
          ),
        ),
      ),
    );
  }
}
