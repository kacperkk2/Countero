import 'package:countero/models/profile.dart';
import 'package:flutter/material.dart';

import '../dates_formatter.dart';

class NewProfileControllers {
  BasicDataControllers data = BasicDataControllers();
  List<FixedCostsControllers> fixedCosts = [];
  List<CategoriesControllers> categories = [];

  FixedCostsControllers convertCostToController(FixedCost cost) {
    FixedCostsControllers controllers = FixedCostsControllers();
    controllers.dateFrom.text = cost.dateFrom.toString();
    controllers.dateTo.text = cost.dateTo.toString();
    controllers.name.text = cost.name.toString();
    controllers.amount.text = cost.amount.toString();
    return controllers;
  }
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

List<Category> createCategoriesList(
    List<CategoriesControllers> categoriesControllers) {
  List<Category> list = [];
  Category category1 = Category();
  category1.id = 0;
  category1.name = "Koszta stale";
  category1.limit = null;
  list.add(category1);

  Category category2 = Category();
  category2.id = 1;
  category2.name = "Domyslna kategoria";
  category2.limit = null;
  list.add(category2);

  int i = 2;
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



