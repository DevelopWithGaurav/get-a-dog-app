import 'package:flutter/material.dart';

import '../model/dog_model.dart';
import '../screen/details_screen.dart';

class DogCard extends StatelessWidget {
  const DogCard({super.key, required this.requiredDogData});

  final DogModel requiredDogData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(DetailsScreen.routeName, arguments: requiredDogData.id),
      child: Column(
        children: [
          SizedBox(
            height: 115,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: requiredDogData.id,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/dog-placeholder.png'),
                      image: NetworkImage(
                        requiredDogData.imageUrl,
                      ),
                      fit: BoxFit.cover,
                      placeholderFit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/dog-placeholder.png');
                      },
                    ),
                    if (requiredDogData.adopted)
                      Positioned.fill(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Already Adopted',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            requiredDogData.name,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${requiredDogData.price}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
