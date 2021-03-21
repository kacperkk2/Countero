// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostRecord _$CostRecordFromJson(Map<String, dynamic> json) {
  return CostRecord(
    name: json['name'] as String,
    amount: (json['value'] as num)?.toDouble(),
    categoryId: json['category_id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$CostRecordToJson(CostRecord instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.amount,
      'category_id': instance.categoryId,
      'date': instance.date?.toIso8601String(),
    };
