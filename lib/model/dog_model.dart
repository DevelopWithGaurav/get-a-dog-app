class DogModel {
  final String id;
  final String name;
  final double age;
  final String imageUrl;
  final double price;
  bool adopted;
  final String breed;
  final int gender;
  DateTime? date;

  DogModel({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.price,
    required this.adopted,
    required this.breed,
    required this.gender,
    this.date,
  });
}
