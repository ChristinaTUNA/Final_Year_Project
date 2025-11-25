import 'package:equatable/equatable.dart';

// --- FILTER STATE MODEL ---
class FilterState extends Equatable {
  final String sortBy;
  final Set<String> cuisines;
  final Set<String> tags;

  const FilterState({
    this.sortBy = '', // 'Prep Time', 'Servings', 'Ratings', 'Popularity'
    this.cuisines = const {},
    this.tags = const {},
  });

  FilterState copyWith({
    String? sortBy,
    Set<String>? cuisines,
    Set<String>? tags,
  }) {
    return FilterState(
      sortBy: sortBy ?? this.sortBy,
      cuisines: cuisines ?? this.cuisines,
      tags: tags ?? this.tags,
    );
  }

  /// Returns true if no filters are applied
  bool get isEmpty => sortBy.isEmpty && cuisines.isEmpty && tags.isEmpty;

  @override
  List<Object?> get props => [sortBy, cuisines, tags];
}
