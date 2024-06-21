import 'dart:io';

import 'package:api_food_store/app/models/category.dart';
import 'package:api_food_store/app/models/food.dart';
import 'package:vania/vania.dart';

class FoodController extends Controller {
  Future<Response> create(Request request, int categoryId) async {
    request.validate({
      "name": "required",
      "price": "required",
    }, {
      "name.required": "name is required",
      "price.required": "price is required",
    });

    final category = await Category()
        .query()
        .where("id", "=", categoryId)
        .whereNull("deleted_at")
        .first();
    if (category == null) {
      return Response.json({
        "message": "Category Not Found",
      }, HttpStatus.notFound);
    }

    RequestFile? image = request.input("image");
    String? imagePath;
    if (image != null) {
      imagePath =
          await image.move(path: publicPath("food"), filename: image.filename);
    }

    Food().query().insert({
      "name": request.input("name"),
      "price": request.input("price"),
      "description": request.input("description"),
      "category_id": categoryId,
      "image": imagePath,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
    });

    return Response.json({"message": "food created !"}, HttpStatus.ok);
  }

  Future<Response> showAll() async{

    // final foodList =await Food().query().whereNull("deleted_at").get();
    
    final foodList = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id").select([
          "food.id",
          "food.name",
          "food.price",
          "food.image",
          "food.description",
          "food.view",
          "food.category_id",
          "category.category_name",
        ])
        .get();

    return Response.json(foodList);
  }

  Future<Response> showLatestsFood() {
    return Response.json({});
  }

  Future<Response> showPopularFood() {
    return Response.json({});
  }

  Future<Response> showSearchFood(Request request) {
    final search = request.query("text");
    return Response.json({});
  }

  Future<Response> increaseViewFood() {
    return Response.json({});
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    return Response.json({});
  }

  Future<Response> destroy(int id) async {
    //! soft delete
    return Response.json({});
  }
}

final FoodController foodController = FoodController();
