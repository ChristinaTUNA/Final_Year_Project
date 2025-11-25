class UserPreferences {
  final Set<String> diets;
  final String timePreference;
  final Set<String> servings;

  const UserPreferences({
    this.diets = const {},
    this.timePreference = '30-60 min',
    this.servings = const {'Just me'},
  });

  Map<String, dynamic> toMap() {
    return {
      'diets': diets.toList(),
      'timePreference': timePreference,
      'servings': servings.toList(),
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      diets: Set<String>.from(map['diets'] ?? []),
      timePreference: map['timePreference'] ?? '30-60 min',
      servings: Set<String>.from(map['servings'] ?? ['Just me']),
    );
  }
}
