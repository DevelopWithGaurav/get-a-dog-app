import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/dogs.dart';
import '../widget/adopted_dog_tile.dart';
import '../widget/http_error_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
      await Provider.of<Dogs>(context, listen: false).fetchAndSetAdoptedDogs();
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
                  builder: (ctx, value, child) => ListView.builder(
                      itemCount: value.allAdoptions.length,
                      itemBuilder: (ct, index) => AdoptedDogTile(
                            requiredDog: value.allAdoptions[index],
                          )),
                ),
              );
  }
}
