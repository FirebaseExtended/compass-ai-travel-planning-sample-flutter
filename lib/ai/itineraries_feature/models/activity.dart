class Activity {
  String ref = '';
  String title = '';
  String description = '';
  String imageUrl = '';

  Activity(
      {required this.ref,
      required this.title,
      required this.description,
      required this.imageUrl});

  static Activity fromJson(Map<String, dynamic> jsonMap) {
    String localRef, localTitle, localDescription, localImageUrl;

    {
      'activityRef': localRef,
      'activityTitle': localTitle,
      'activityDesc': localDescription,
      'imgUrl': localImageUrl
    } = jsonMap;

    return Activity(
        ref: localRef,
        title: localTitle,
        description: localDescription,
        imageUrl: localImageUrl);
  }
}
