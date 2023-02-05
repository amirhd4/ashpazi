class FoodTutorial {
  int id;
  String foodName;
  String foodDescription;
  String foodCategory;
  String foodImage;
  FoodTutorial({
    required this.id,
    required this.foodName,
    required this.foodDescription,
    required this.foodCategory,
    required this.foodImage,
  });
}

class FoodTutorialCategory {
  String province;
  int categoryCount;
  List<FoodTutorial> foodTutorial;
  FoodTutorialCategory({
    required this.province,
    this.categoryCount = 0,
    required this.foodTutorial,
  });
}
