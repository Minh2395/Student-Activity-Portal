class ActivityCategoryModel {
  final int categoryId;
  final String categoryName;
  final String? description;

  const ActivityCategoryModel({
    required this.categoryId,
    required this.categoryName,
    this.description,
  });

  factory ActivityCategoryModel.fromJson(Map<String, dynamic> json) {
    return ActivityCategoryModel(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
    };
  }
}
