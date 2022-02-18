class Recipe {
  int? id;
  String? label;
  String? image;
  String? url;
  int? calories;
  String? totalWeight;
  String? totalTime;

  Recipe({
    int? id,
    String? label,
    String? image,
    String? url,
    int? calories,
    String? totalWeight,
    String? totalTime,
  });

// Create a Recipe from JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['recipeId'],
        label: json['label'],
        image: json['image'],
        url: json['url'],
        calories: json['calories'],
        totalWeight: json['totalWeight'],
        totalTime: json['totalTime'],
      );

// Convert our Recipe to JSON to make it easier when you store
// it in the database
  Map<String, dynamic> toJson() => {
        'recipeId': id,
        'label': label,
        'image': image,
        'url': url,
        'calories': calories,
        'totalWeight': totalWeight,
        'totalTime': totalTime,
      };
}
