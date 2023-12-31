import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../data_model/category_response.dart';


class CategoryRepository {

  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    final response =
    await http.get(Uri.parse("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}"));
    print("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}");
    print(response.body.toString());
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    final response =
        await http.get(Uri.parse("${AppConfig.BASE_URL}/categories/featured"));
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    final response =
    await http.get(Uri.parse("${AppConfig.BASE_URL}/categories/top"));
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    final response =
    await http.get(Uri.parse("${AppConfig.BASE_URL}/filter/categories"));
    return categoryResponseFromJson(response.body);
  }


}
