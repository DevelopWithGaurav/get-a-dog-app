import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widget/http_error_widget.dart';
import '../widget/dog_card.dart';
import '../constant.dart';
import '../provider/dogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _httpErrorOccured = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _httpErrorOccured = false;
    });
    try {
      await Provider.of<Dogs>(context, listen: false).fetchAndSetDogs();
    } catch (error) {
      setState(() {
        _httpErrorOccured = true;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Something went wrong!!!'),
          content: const Text('Please try again after some time'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _httpErrorOccured
            ? HttpErrorWidget(reload: _loadData)
            : RefreshIndicator(
                onRefresh: () => _loadData(),
                child: Consumer<Dogs>(
                  builder: (context, value, child) => GridView.builder(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    itemCount: value.allDogs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ((MediaQuery.of(context).size.width / 392) * 2)
                              .round(),
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 7,
                    ),
                    itemBuilder: (ctx, index) => DogCard(
                      requiredDogData: value.allDogs[index],
                    ),
                  ),
                ),
              );
  }
}
