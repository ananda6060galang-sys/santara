class RecipeModel {

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final int cookingTime;
  final String category;
  final String ingredients;
  final String steps;
  final int servings;
  final String difficulty;

  RecipeModel({

    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.cookingTime,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.difficulty,
  });

  factory RecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return RecipeModel(

      id:
          json['id'] ?? '',

      title:
          json['title'] ?? '',

      description:
          json['description'] ?? '',

      imageUrl:
          json['image_url'] ?? '',

      location:
          json['location'] ?? '',

      cookingTime:
          json['cooking_time'] ?? 0,

      category:
          json['categories']?['name'] ?? '',

      ingredients:
          json['ingredients'] ?? '',

      steps:
          json['steps'] ?? '',

      servings:
          json['servings'] ?? 0,

      difficulty:
          json['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id':
          id,

      'title':
          title,

      'description':
          description,

      'image_url':
          imageUrl,

      'location':
          location,

      'cooking_time':
          cookingTime,

      'category_id':
          category,

      'ingredients':
          ingredients,

      'steps':
          steps,

      'servings':
          servings,

      'difficulty':
          difficulty,
    };
  }
}