import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';
import '../model/dog_model.dart';

class AdoptedDogTile extends StatelessWidget {
  const AdoptedDogTile({
    Key? key,
    required this.requiredDog,
  }) : super(key: key);

  final DogModel requiredDog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kDefaultPadding,
        kDefaultPadding / 2,
        kDefaultPadding,
        kDefaultPadding / 2,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/dog-placeholder.png'),
                image: NetworkImage(requiredDog.imageUrl),
                fit: BoxFit.cover,
                placeholderFit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/dog-placeholder.png');
                },
              ),
            ),
          ),
          const SizedBox(width: kDefaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requiredDog.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Adopted on ${DateFormat.yMMMMd().format(requiredDog.date!)}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
