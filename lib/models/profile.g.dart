// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    dateFrom: json['date_from'] == null
        ? null
        : DateTime.parse(json['date_from'] as String),
    dateTo: json['date_to'] == null
        ? null
        : DateTime.parse(json['date_to'] as String),
    earnings: (json['earnings'] as num)?.toDouble(),
    target: (json['target'] as num)?.toDouble(),
    fixedCosts: (json['fixed_costs'] as List)
        ?.map((e) =>
            e == null ? null : FixedCost.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    categories: (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'date_from': instance.dateFrom?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'earnings': instance.earnings,
      'target': instance.target,
      'fixed_costs': instance.fixedCosts?.map((e) => e?.toJson())?.toList(),
      'categories': instance.categories?.map((e) => e?.toJson())?.toList(),
    };

FixedCost _$FixedCostFromJson(Map<String, dynamic> json) {
  return FixedCost(
    dateFrom: json['date_from'] == null
        ? null
        : DateTime.parse(json['date_from'] as String),
    dateTo: json['date_to'] == null
        ? null
        : DateTime.parse(json['date_to'] as String),
    name: json['name'] as String,
    amount: (json['amount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FixedCostToJson(FixedCost instance) => <String, dynamic>{
      'date_from': instance.dateFrom?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'name': instance.name,
      'amount': instance.amount,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as int,
    limit: (json['limit'] as num)?.toDouble(),
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'limit': instance.limit,
      'name': instance.name,
    };
