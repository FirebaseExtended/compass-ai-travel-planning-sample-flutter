class Activity {
  int duration;
  String ref;
  String locationName;
  double price;
  String imageUrl;
  String destination;
  String name;
  String description;
  bool familyFriendly;
  String timeOfDay;

  Activity({
    required this.duration,
    required this.ref,
    required this.locationName,
    required this.price,
    required this.imageUrl,
    required this.destination,
    required this.name,
    required this.description,
    required this.familyFriendly,
    required this.timeOfDay,
  });

  @override
  String toString() {
    return 'Activity(ref: $ref, name: $name, duration: $duration, locationName: $locationName, price: $price, destination: $destination, imageUrl: $imageUrl, description: $description, familyFriendly: $familyFriendly, timeOfDay: $timeOfDay)';
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      duration: json['duration'] as int,
      ref: json['ref'] as String,
      locationName: json['locationName'] as String,
      price: json['price'] as double,
      imageUrl: json['imageUrl'] as String,
      destination: json['destination'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      familyFriendly: json['familyFriendly'] as bool,
      timeOfDay: json['timeOfDay'] as String,
    );
  }
}
