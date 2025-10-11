import '../models/recipe_model.dart';

class HomeViewModel {
  final List<Recipe> quickMeals = [
    Recipe(
      image: 'assets/images/spaghetti.jpg',
      title: 'Creamy Spaghetti',
      subtitle1: 'Pasta',
      subtitle2: 'Quick & Easy',
      rating: 4.8,
      time: '15 min',
    ),
    Recipe(
      image: 'assets/images/salad.jpg',
      title: 'Fresh Salad Bowl',
      subtitle1: 'Healthy',
      subtitle2: 'Light',
      rating: 4.6,
      time: '10 min',
    ),
  ];

  final List<Recipe> cookNowMeals = [
    Recipe(
      image: 'assets/images/friedrice.jpg',
      title: 'Fried Rice',
      subtitle1: 'Asian',
      subtitle2: 'Comfort Food',
      rating: 4.7,
      time: '20 min',
    ),
    Recipe(
      image: 'assets/images/soup.jpg',
      title: 'Tomato Soup',
      subtitle1: 'Soup',
      subtitle2: 'Hot & Fresh',
      rating: 4.5,
      time: '15 min',
    ),
  ];
}
