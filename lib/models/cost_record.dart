import 'package:json_annotation/json_annotation.dart';

part 'cost_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CostRecord {
  String name;
  double amount;
  int categoryId;
  DateTime date;

  CostRecord({
    this.name,
    this.amount,
    this.categoryId,
    this.date
  });

  factory CostRecord.fromJson(Map<String, dynamic> json) => _$CostRecordFromJson(json);
  Map<String, dynamic> toJson() => _$CostRecordToJson(this);

  IndexedCostRecord toIndexed(int idx) {
    return IndexedCostRecord(index: idx, name: name, categoryId: categoryId, value: amount, date: date);
  }
}

class IndexedCostRecord {
  int index;
  String name;
  double value;
  int categoryId;
  DateTime date;

  IndexedCostRecord({
    this.index,
    this.name,
    this.value,
    this.categoryId,
    this.date
  });
}

class GroupedCostRecords {
  List<IndexedCostRecord> records;
  double moneyPaid;
  double moneySaved;
  double monthTarget;
  DateTime date;

  GroupedCostRecords({
    this.records, 
    this.moneyPaid,
    this.moneySaved,
    this.monthTarget,
    this.date
  });

  @override
  String toString() {
    return "$moneySaved, $moneyPaid, $monthTarget, $records, $date";
  }
}