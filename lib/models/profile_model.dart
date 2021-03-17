import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:countero/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel with ChangeNotifier {
    Profile _profile;
    bool _profileLoaded = false;

    Profile get profile => _profile;
    bool get profileLoaded => _profileLoaded;

    Future<Profile> loadProfile() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var planConfigString = sharedPreferences.getString("Profile") ?? null;
        _profileLoaded = true;
        return planConfigString == null
            ? null
            : null; //TODO return loaded profile
    }

    void deleteProfile() async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove("Profile");
    }

    void setProfile(Profile profile) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("Profile", jsonEncode(profile));
    }
}