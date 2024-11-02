import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Text("\$120",style: Theme.of(context).textTheme.labelLarge,),
        SizedBox(width: 4,),
        RichText(
          text: TextSpan(
            text: '\$100',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
        )
      ],
    );
  }
}
