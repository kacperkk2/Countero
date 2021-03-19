import 'package:countero/models/profile.dart';
import 'package:flutter/material.dart';

import '../dates_formatter.dart';

class NewProfileControllers {
  BasicDataControllers data = BasicDataControllers();
  List<FixedCostsControllers> fixedCosts = [];
  List<CategoriesControllers> categories = [];
}

class BasicDataControllers {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  TextEditingController earnings = TextEditingController();
  TextEditingController target = TextEditingController();
}

class FixedCostsControllers {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
}

class CategoriesControllers {
  TextEditingController name = TextEditingController();
  TextEditingController limit = TextEditingController();
}

Profile controllersToProfile(NewProfileControllers controllers) {
  Profile newProfile = Profile();
  newProfile.earnings = double.parse(controllers.data.earnings.text);
  newProfile.target = double.parse(controllers.data.target.text);
  newProfile.dateFrom = toDateTime(controllers.data.dateFrom.text);
  newProfile.dateTo = setDayAsLast(toDateTime(controllers.data.dateTo.text));
  newProfile.fixedCosts = createFixedCostsList(controllers.fixedCosts);
  newProfile.categories = createCategoriesList(controllers.categories);
  return newProfile;
}

List<FixedCost> createFixedCostsList(List<FixedCostsControllers> fixedCostsControllers) {
  return fixedCostsControllers
      .map((fixedCostElement) => createFixedCost(fixedCostElement))
      .toList();
}

FixedCost createFixedCost(FixedCostsControllers fixedCostElement) {
  FixedCost fixedCost = FixedCost();
  fixedCost.name = fixedCostElement.name.text;
  fixedCost.amount = double.parse(fixedCostElement.amount.text);
  fixedCost.dateFrom = toDateTime(fixedCostElement.dateFrom.text);
  fixedCost.dateTo = toDateTime(fixedCostElement.dateTo.text);
  return fixedCost;
}

List<Category> createCategoriesList(List<CategoriesControllers> categoriesControllers) {
  List<Category> list = [];
  int i = 0;
  for (var controller in categoriesControllers) {
    Category category = Category();
    category.id = i;
    category.name = controller.name.text;
    category.limit = controller.limit.text.isEmpty
        ? null
        : double.parse(controller.limit.text);
    list.add(category);
    i++;
  }
  return list;
}



