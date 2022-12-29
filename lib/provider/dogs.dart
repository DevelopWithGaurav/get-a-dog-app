import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/dog_model.dart';

class Dogs with ChangeNotifier {
  // dark mode - START
  bool _darkMode = false;

  bool get darkMode {
    return _darkMode;
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
  // dark mode - END

  List<DogModel> _allDogs = [];

  List<DogModel> get allDogs {
    return [..._allDogs];
  }

  Future<void> fetchAndSetDogs() async {
    final url = Uri.parse(
      'https://nymble-task-default-rtdb.asia-southeast1.firebasedatabase.app/dogs.json',
    );

    try {
      final response = await http.get(
        url,
      );
      final extractedData = json.decode(response.body) as Map;

      _allDogs = [];
      extractedData.forEach((key, value) {
        _allDogs.add(
          DogModel(
            id: key.toString(),
            name: value['name'].toString(),
            age: double.parse(value['age']),
            imageUrl: value['imageUrl'].toString(),
            price: double.parse(value['price']),
            adopted: value['adopted'] == 0 ? false : true,
            breed: value['breed'].toString(),
            gender: value['gender'],
            date: value['adopted'] == 1 ? DateTime.parse(value['date']) : null,
          ),
        );
      });

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  DogModel findDogById(String id) {
    return _allDogs.firstWhere((element) => element.id == id);
  }

  // ADOPT - START
  List<DogModel> _allAdoptions = [];

  List<DogModel> get allAdoptions {
    return [..._allAdoptions];
  }

  Future<void> adoptDog(DogModel adoptedDog) async {
    final dogIndex =
        _allDogs.indexWhere((element) => element.id == adoptedDog.id);
    final url = Uri.parse(
      'https://nymble-task-default-rtdb.asia-southeast1.firebasedatabase.app/dogs/${adoptedDog.id}.json',
    );

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'adopted': 1,
          'date': DateTime.now().toString(),
        }),
      );

      _allDogs[dogIndex].adopted = true;
      _allDogs[dogIndex].date =
          DateTime.parse(json.decode(response.body)['date']);
      notifyListeners();
      fetchAndSetAdoptedDogs();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetAdoptedDogs() async {
    try {
      await fetchAndSetDogs();
      _allAdoptions = [];
      for (var i in _allDogs) {
        if (i.adopted) {
          _allAdoptions.add(i);
        }
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
  // ADOPT - END
}
