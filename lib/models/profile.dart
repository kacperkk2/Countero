import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Profile {
  DateTime dateFrom;
  DateTime dateTo;
  double earnings;
  double target;
  List<FixedCost> fixedCosts;
  List<Category> categories;

  Profile({
    this.dateFrom,
    this.dateTo,
    this.earnings,
    this.target,
    this.fixedCosts,
    this.categories
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FixedCost {
  DateTime dateFrom;
  DateTime dateTo;
  String name;
  double amount;

  FixedCost({
    this.dateFrom,
    this.dateTo,
    this.name,
    this.amount
  });

  factory FixedCost.fromJson(Map<String, dynamic> json) => _$FixedCostFromJson(json);
  Map<String, dynamic> toJson() => _$FixedCostToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  int id;
  double limit;
  String name;

  Category({
    this.id,
    this.limit,
    this.name
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}