import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:countero/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel with ChangeNotifier {
    Profile _profile;
    bool _profileLoaded = false;

    Profile get profile => _profile;
    bool get profileLoaded => _profileLoaded;
    
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

    void deleteProfile() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove("Profile");
    }

    void saveProfile(Profile profile) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("Profile", jsonEncode(profile));
    }
}