import 'package:flutter/material.dart';
import 'package:machine_test_rearrange/core/pretty_printer.dart';
import 'package:machine_test_rearrange/core/usecase.dart';
import 'package:machine_test_rearrange/rearrange/data/models/product_model.dart';
import 'package:machine_test_rearrange/rearrange/domain/use_cases/get_categories_use_case.dart';
import 'package:machine_test_rearrange/rearrange/domain/use_cases/get_product_use_case.dart';

import '../../../core/response_classify.dart';
import '../../../injector.dart';

class HomeController with ChangeNotifier {
  HomeController() {
    if (categoryResponse.data == null) {
      getCategories();
    }
  }
  var categoryResponse = ResponseClassify<List<String>>.error("");
  var productResponse = ResponseClassify<List<ProductModel>>.error("");

  GetProductsUseCase productsUseCase = sl();
  GetCategoriesUseCase categoriesUseCase = sl();

  getProducts(String cat) async {
    productResponse = ResponseClassify.loading();
    notifyListeners();
    try {
      productResponse =
          ResponseClassify.completed(await productsUseCase.call(cat));
      notifyListeners();
    } catch (e) {
      productResponse = ResponseClassify.error(e.toString());
      notifyListeners();
    }
  }

  List<ProductModel> selectedProducts = [];
  changeSelected(ProductModel model, {required BuildContext context}) {
    if (selectedProducts.contains(model)) {
      selectedProducts.remove(model);
    } else {
      if (selectedProducts.length >= 6) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Only 6 products can be selected")));
      } else {
        selectedProducts.add(model);
      }
    }
    notifyListeners();
  }

  getCategories() async {
    categoryResponse = ResponseClassify.loading();
    notifyListeners();
    try {
      categoryResponse =
          ResponseClassify.completed(await categoriesUseCase.call(NoParams()));
      prettyPrint("count ${categoryResponse.data?.length}");
      if (categoryResponse.data!.isNotEmpty) {
        selectedCategory = categoryResponse.data!.first;
        getProducts(selectedCategory);
      }

      notifyListeners();
    } catch (e) {
      categoryResponse = ResponseClassify.error(e.toString());
    }
  }

  String selectedCategory = "";
  changeSelectedCat(String cat) {
    selectedCategory = cat;
    getProducts(cat);
    notifyListeners();
  }
}
