import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:countero/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dates_formatter.dart';
import 'cost_record.dart';

class ProfileModel with ChangeNotifier {
    Profile _profile;
    List<CostRecord> _records = [];
    bool _profileLoaded = false;

    Profile get profile => _profile;
    bool get profileLoaded => _profileLoaded;
    List<CostRecord> get records => _records;
    
    set profile(Profile profileToSet) {
        _profile = profileToSet;
        _profileLoaded = true;
        saveProfile(profile);
        notifyListeners();
    }

    Future<Profile> loadProfile() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var planConfigString = sharedPreferences.getString("Profile") ?? null;
        _profileLoaded = true;
        return planConfigString == null
            ? null
            : Profile.fromJson(jsonDecode(planConfigString));
    }

    void deleteProfileFromSharedPref() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove("Profile");
    }

    void saveProfile(Profile profile) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("Profile", jsonEncode(profile));
    }

    void deleteProfile() {
        _profile = null;
        deleteProfileFromSharedPref();
        notifyListeners();
    }

    List<DateTime> getProfileDateRange({tillNow = true}) {
        DateTime dateTo;
        if (tillNow) {
            dateTo = DateTime.now().isAfter(_profile.dateTo)
                ? _profile.dateTo
                : DateTime.now();
            if (dateTo.isBefore(_profile.dateFrom)) {
                dateTo = _profile.dateTo;
            }
        } else {
            dateTo = _profile.dateTo;
        }
        return generateRangeInMonths(_profile.dateFrom, dateTo);
    }

    // CostRecords
    set records(List<CostRecord> records) {
        records.sort((b, a) => a.date.compareTo(b.date));
        _records = records;
        saveCostRecords(records);
        notifyListeners();
    }

    void saveCostRecords(List<CostRecord> records) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("CostRecords", jsonEncode(records));
    }

    Future<List<CostRecord>> loadCostRecords() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var records = prefs.getString("CostRecords") ?? null;
        if (records == null) {
            return [];
        }
        Iterable recordsDecoded = jsonDecode(records);
        return List<dynamic>.from(recordsDecoded)
            .map((model) => CostRecord.fromJson(model))
            .toList();
    }

    void deleteCostRecordsFromSharedPref() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("CostRecords");
    }

    CostRecord getCostRecordByIndex(int idx) {
        return _records[idx];
    }

    void saveSingleCostRecordWithIndex(int idx, CostRecord record) {
        _records[idx] = record;
        records = _records;
    }

    void saveSingleCostRecord(CostRecord record) {
        _records.add(record);
        records = _records;
    }

    void deleteCostRecords() {
        _records = [];
        deleteCostRecordsFromSharedPref();
        notifyListeners();
    }

    void deleteCostRecordByIndex(int idx) {
        _records.removeAt(idx);
        records = _records;
    }

    Map<DateTime, GroupedCostRecords> getCostRecordsDividedByDateRange(
        List<DateTime> dateRange, Profile profile) {
        
        Map<DateTime, GroupedCostRecords> result = Map<DateTime, GroupedCostRecords>();
        var toSaveInMonth = getDatesMonthDiff(profile.dateFrom, profile.dateTo) + 1;
        groupCostRecords(
            dateRange, 
            result, 
            toSaveInMonth,
            profile.target, 
            profile.earnings
        );
        return result;
    }

    void groupCostRecords(
        List<DateTime> dateRange,
        Map<DateTime, GroupedCostRecords> result,
        int toSaveInMonth,
        double target,
        double earnings) {
        var reversedCostRecords = _records.reversed.toList();

        for (int i = 0, j = 0; i < dateRange.length; ++i) {
            DateTime date = dateRange[i];
            List<IndexedCostRecord> list = [];
            double moneyPaid = 0;
            int monthsLeft = toSaveInMonth - i;
            bool alreadyAdded = false;

            for (; j < reversedCostRecords.length; ++j) {
                CostRecord record = reversedCostRecords[j];
                if (record.date.month == date.month && record.date.year == date.year) {
                    list.add(record.toIndexed(reversedCostRecords.length - 1 - j));
                    moneyPaid += record.amount;
                } else {
                    target = addToMap(
                        result, date, list, moneyPaid, target, earnings, monthsLeft);
                    alreadyAdded = true;
                    break;
                }
                if (j == reversedCostRecords.length - 1 && !alreadyAdded) {
                    target = addToMap(
                        result, date, list, moneyPaid, target, earnings, monthsLeft);
                    alreadyAdded = true;
                }
            }
            if (j == reversedCostRecords.length && !alreadyAdded) {
                target = addToMap(
                    result, date, list, moneyPaid, target, earnings, monthsLeft);
                alreadyAdded = true;
            }
            if (i == 0 && !alreadyAdded) {
                target = addToMap(
                    result, date, list, moneyPaid, target, earnings, monthsLeft);
                alreadyAdded = true;
            }
        }
    }

    double addToMap(
        Map<DateTime, GroupedCostRecords> result,
        DateTime date,
        List<IndexedCostRecord> buffer,
        double moneyPaid,
        double spareGoal,
        double monthlyIncome, int monthsLeft) {

        double moneySaved = monthlyIncome - moneyPaid;
        double monthTarget = spareGoal / monthsLeft;
        spareGoal -= moneySaved;
        result.putIfAbsent(
            date,
            () => GroupedCostRecords(
                records: buffer.reversed.toList(),
                moneyPaid: moneyPaid,
                moneySaved: moneySaved,
                monthTarget: monthTarget,
                date: date
            ),
        );
        return spareGoal < 0 ? 0 : spareGoal;
    }

    Map<int, Category> get categoriesMap {
        return Map.fromIterable(profile.categories, key: (e) => e.id, value: (e) => e);
    }
}


// Test data
Profile createTestProfile() {
    Profile testProfile = Profile();
    testProfile.earnings = 6000.0;
    testProfile.target = 4000.0;
    testProfile.dateFrom = DateTime(2020, 1, 1);
    testProfile.dateTo = DateTime(2020, 5, 1);
    testProfile.fixedCosts = [
        FixedCost(
            dateFrom: DateTime(2020, 1, 1),
            dateTo: DateTime(2020, 5, 1),
            name: 'Czynsz',
            amount: 1300.0
        ),
        FixedCost(
            dateFrom: DateTime(2020, 1, 1),
            dateTo: DateTime(2020, 3, 1),
            name: 'MultiSport',
            amount: 150.0
        ),
        FixedCost(
            dateFrom: DateTime(2020, 2, 1),
            dateTo: DateTime(2020, 5, 1),
            name: 'Medicover',
            amount: 300.0
        ),
    ];
    testProfile.categories = [
        Category(id: 0, name: "Koszta stale"),
        Category(id: 1, name: "Domyslna kategoria"),
        Category(id: 2, name: "Rozrywka", limit: 500),
        Category(id: 3, name: "Jedzenie", limit: 800),
        Category(id: 4, name: "Imprezy", limit: 200),
    ];
    return testProfile;
}

List<CostRecord> createTestCostRecords() {
    int month = 1;
    List<CostRecord> records = [];
    records.add(CostRecord(name: 'Czynsz', amount: 1300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'MultiSport', amount: 150.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Gokarty', amount: 100.0, categoryId: 2, date: DateTime(2020, month, 4)));
    records.add(CostRecord(name: 'Biedra', amount: 200.0, categoryId: 3, date: DateTime(2020, month, 10)));
    records.add(CostRecord(name: 'Urodziny Andrzeja', amount: 150.0, categoryId: 4, date: DateTime(2020, month, 12)));
    records.add(CostRecord(name: 'Żabka', amount: 300.0, categoryId: 3, date: DateTime(2020, month, 19)));
    records.add(CostRecord(name: 'Grube zakupy', amount: 200.0, categoryId: 3, date: DateTime(2020, month, 23)));
    records.add(CostRecord(name: 'Wisełka', amount: 75.0, categoryId: 4, date: DateTime(2020, month, 26)));
    records.add(CostRecord(name: 'Trampoliny', amount: 100.0, categoryId: 2, date: DateTime(2020, month, 29)));
    month++;
    records.add(CostRecord(name: 'Czynsz', amount: 1300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'MultiSport', amount: 150.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Medicover', amount: 300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Wycieczka', amount: 800.0, categoryId: 2, date: DateTime(2020, month, 9)));
    records.add(CostRecord(name: 'Pizza', amount: 50.0, categoryId: 3, date: DateTime(2020, month, 10)));
    records.add(CostRecord(name: 'Spontaniczne wyjście', amount: 60.0, categoryId: 4, date: DateTime(2020, month, 11)));
    records.add(CostRecord(name: 'Zakupy', amount: 500.0, categoryId: 3, date: DateTime(2020, month, 15)));
    records.add(CostRecord(name: 'Zakupy', amount: 200.0, categoryId: 3, date: DateTime(2020, month, 19)));
    records.add(CostRecord(name: 'Piwko', amount: 50.0, categoryId: 4, date: DateTime(2020, month, 26)));
    records.add(CostRecord(name: 'Ścianka wspinaczkowa', amount: 35.0, categoryId: 2, date: DateTime(2020, month, 27)));
    month++;
    records.add(CostRecord(name: 'Czynsz', amount: 1300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'MultiSport', amount: 150.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Medicover', amount: 300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Wycieczka', amount: 400.0, categoryId: 2, date: DateTime(2020, month, 3)));
    records.add(CostRecord(name: 'Restauracja', amount: 100.0, categoryId: 3, date: DateTime(2020, month, 13)));
    records.add(CostRecord(name: 'Spontaniczne wyjście', amount: 60.0, categoryId: 4, date: DateTime(2020, month, 15)));
    records.add(CostRecord(name: 'Zakupy', amount: 700.0, categoryId: 3, date: DateTime(2020, month, 15)));
    records.add(CostRecord(name: 'Zakupy', amount: 300.0, categoryId: 3, date: DateTime(2020, month, 19)));
    month++;
    records.add(CostRecord(name: 'Czynsz', amount: 1300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Medicover', amount: 300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Darty i bilard', amount: 100.0, categoryId: 2, date: DateTime(2020, month, 15)));
    records.add(CostRecord(name: 'Zakupy', amount: 550.0, categoryId: 3, date: DateTime(2020, month, 16)));
    records.add(CostRecord(name: 'Urodziny Michała', amount: 60.0, categoryId: 4, date: DateTime(2020, month, 17)));
    records.add(CostRecord(name: 'Zakupy', amount: 200.0, categoryId: 3, date: DateTime(2020, month, 28)));
    records.add(CostRecord(name: 'Komputer', amount: 6000.0, categoryId: 2, date: DateTime(2020, month, 28)));
    month++;
    records.add(CostRecord(name: 'Czynsz', amount: 1300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Medicover', amount: 300.0, categoryId: 0, date: DateTime(2020, month, 1)));
    records.add(CostRecord(name: 'Majówka', amount: 1000.0, categoryId: 2, date: DateTime(2020, month, 3)));
    records.add(CostRecord(name: 'Pizza', amount: 50.0, categoryId: 3, date: DateTime(2020, month, 10)));
    records.add(CostRecord(name: 'Wieczór u Karola', amount: 60.0, categoryId: 4, date: DateTime(2020, month, 11)));
    records.add(CostRecord(name: 'Zakupy', amount: 300.0, categoryId: 3, date: DateTime(2020, month, 15)));
    records.add(CostRecord(name: 'Zakupy', amount: 400.0, categoryId: 3, date: DateTime(2020, month, 19)));
    records.add(CostRecord(name: 'Piwko', amount: 50.0, categoryId: 4, date: DateTime(2020, month, 26)));
    records.add(CostRecord(name: 'Trampoliny', amount: 35.0, categoryId: 2, date: DateTime(2020, month, 27)));
    return records;
}