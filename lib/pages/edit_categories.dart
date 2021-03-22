import 'package:countero/forms/new_profile_controllers.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:countero/forms/new_profile_form.dart';
import 'package:provider/provider.dart';

import 'create_profile.dart';

class EditCategories extends StatefulWidget {
  @override
  _EditCategoriesState createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  List<CategoriesControllers> categoriesControllers = [];
  final formKey = GlobalKey<FormState>();
  ProfileModel profileModel;

  @override
  void initState() {
    super.initState();
    profileModel = Provider.of<ProfileModel>(context, listen: false);
    updateCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edycja kategorii"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Usunięcie kategorii przypisanej do rekordów spowoduje "
                      "przypisanie tych rekordów do kategorii domyślnej",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontSize: 14.0,
                    ),
                ),
              ),
              CategoriesSection(
                controllers: categoriesControllers,
                categoriesCount: categoriesControllers.length
              ),
              SizedBox(height: 30.0)
            ]
          )
        ),
        floatingActionButton: CustomSaveButton(
            formKey: formKey, onClick: () => updateProfile(context)
        )
    );
  }

  void updateProfile(BuildContext context) {
    List<Category> oldCategories = profileModel.profile.categories;
    // for (var category in oldCategories) {
    //   print("${category.name}, ${category.id}");
    // }
    profileModel.profile.categories = createCategoriesList(categoriesControllers);
    Map<int, int> oldToNewCategoriesId = {};
    for (var oldCategory in oldCategories) {
      bool found = false;
      for (var newCategory in profileModel.profile.categories) {
        if (oldCategory.name == newCategory.name) {
          oldToNewCategoriesId[oldCategory.id] = newCategory.id;
          found = true;
          break;
        }
      }
      if (!found) {
        oldToNewCategoriesId[oldCategory.id] = 1; // domyslna kategoria
      }
    }

    for (var record in profileModel.records) {
      record.categoryId = oldToNewCategoriesId[record.categoryId];
    }
    Navigator.pop(context);
  }

  void updateCategories() {
    categoriesControllers = profileModel.profile.categories
        .map((category) => convertCategoryToController(category))
        .toList();
    categoriesControllers.removeAt(0); // koszty stale
    categoriesControllers.removeAt(0); // domyslna kategoria
  }

  CategoriesControllers convertCategoryToController(Category category) {
    CategoriesControllers controllers = CategoriesControllers();
    controllers.name.text = category.name.toString();
    controllers.limit.text = category.limit == null ? "" : category.limit.toString();
    return controllers;
  }
}


