import 'dart:io';

import 'package:api_food_store/app/models/category.dart';
import 'package:vania/vania.dart';

class CategoryController extends Controller {
  //! create
  Future<Response> create(Request req) async {
    req.validate({"name": "required"}, {"name.required": "Name is required"});

    await Category().query().insert({
      "category_name": req.input("name"),
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    });

    return Response.json(
      {"message": "Category Created!"},
    );
  }

  //! show all
  Future<Response> showAll() async {
    final categoryLST = await Category().query().whereNull("deleted_at").get();
    return Response.json(categoryLST);
  }

  //! update
  Future<Response> update(Request request, int id) async {
    final singleCategory = await Category()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (singleCategory == null) {
      return Response.json(
          {"message": "category not found"}, HttpStatus.notFound);
    }
    

    await Category()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .update({
      "category_name": request.query("name") ?? singleCategory["category_name"],
      "updated_at": DateTime.now()
    });

    return Response.json({"message": "Category Updated!"});
  }

  //! soft delete
  Future<Response> destroy(int id) async {
    final singleCategory = await Category()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (singleCategory == null) {
      return Response.json(
          {"message": "category not found"}, HttpStatus.notFound);
    }
    print(singleCategory);

    await Category()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .update({"deleted_at": DateTime.now()});

    return Response.json({"message": "category deleted!"});
  }
}

final CategoryController categoryController = CategoryController();
