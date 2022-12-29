import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constant.dart';
import '../model/dog_model.dart';
import '../provider/dogs.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  static const routeName = '/details-screen';

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _adoptMeIsLoading = false;

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final loadedDog = Provider.of<Dogs>(context, listen: false).findDogById(id);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedDog.name),
              titlePadding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding,
              ),
              centerTitle: true,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: loadedDog.id,
                    child: Image.network(
                      loadedDog.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: <Color>[
                          Colors.black45,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: kDefaultPadding),
                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 1,
                  ),
                  children: [
                    detailItem(
                        context, 'Age', ageText(loadedDog.age), loadedDog),
                    detailItem(context, 'Breed', loadedDog.breed, loadedDog),
                    detailItem(context, 'Gender',
                        loadedDog.gender == 0 ? 'Male' : 'Female', loadedDog),
                    detailItem(context, 'Adopted', null, loadedDog),
                  ],
                ),
                const SizedBox(height: kDefaultPadding),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas et risus ut libero facilisis faucibus. Aliquam id elit non tortor lacinia mollis eu at lorem. Sed in magna tempor, viverra sem eget, fermentum nibh. Etiam pharetra vestibulum orci quis lobortis. Cras et arcu vel nunc rutrum vestibulum. Fusce quam purus, aliquet ut felis et, auctor suscipit risus. Etiam bibendum sapien quis massa dignissim, quis lobortis quam ultricies.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailItem(BuildContext context, String heading, String? value,
      DogModel requiredDog) {
    return value != null
        ? Consumer<Dogs>(
            builder: (context, dvalue, child) => Container(
              decoration: BoxDecoration(
                color: dvalue.darkMode ? Colors.grey.shade800 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: dvalue.darkMode
                        ? Colors.grey.shade900
                        : Colors.grey.shade300,
                    offset: const Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(heading.toUpperCase()),
                  const SizedBox(height: 10),
                  Text(
                    value.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: requiredDog.adopted
                ? null
                : () async {
                    setState(() {
                      _adoptMeIsLoading = true;
                    });
                    await Provider.of<Dogs>(context, listen: false)
                        .adoptDog(requiredDog);
                    _showpopup(requiredDog.name);
                    setState(() {
                      _adoptMeIsLoading = false;
                    });
                  },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    requiredDog.adopted ? Colors.grey.shade300 : Colors.white,
                boxShadow: [
                  if (!requiredDog.adopted)
                    BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6),
                      offset: const Offset(4, 4),
                    ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: _adoptMeIsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      requiredDog.adopted ? 'Already Adopted' : 'ADOPT ME',
                      style: TextStyle(
                          color: requiredDog.adopted
                              ? Colors.grey.shade600
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                          wordSpacing: 5),
                    ),
            ),
          );
  }

  _showpopup(String name) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('You\'ve now adopted $name'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  String ageText(double age) {
    if (age < 1) {
      return '${(age * 12).round()} months';
    } else if (age == 1) {
      return '${age.round()} year';
    } else {
      // age > 1
      return '${age.round()} years';
    }
  }
}
