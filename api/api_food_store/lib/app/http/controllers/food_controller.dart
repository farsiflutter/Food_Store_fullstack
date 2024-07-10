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

  Future<Response> showAll() async {
    // final foodList =await Food().query().whereNull("deleted_at").get();

    final foodList = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id")
        .select([
      "food.id",
      "food.name",
      "food.price",
      "food.image",
      "food.description",
      "food.view",
      "food.category_id",
      "category.category_name",
    ]).get();

    return Response.json(foodList);
  }

  Future<Response> showLatestsFood() async {
    print("object");
    final latestFood = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id")
        .orderBy("food.created_at", "desc")
        .select([
      "food.id",
      "food.name",
      "food.price",
      "food.image",
      "food.description",
      "food.view",
      "food.category_id",
      "category.category_name",
    ]).get();
    return Response.json(latestFood);
  }

  Future<Response> showPopularFood() async {
    final popularFood = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id")
        .orderBy("food.view", "desc")
        .select([
      "food.id",
      "food.name",
      "food.price",
      "food.image",
      "food.description",
      "food.view",
      "food.category_id",
      "category.category_name",
    ]).get();

    return Response.json(popularFood);
  }

  Future<Response> showSearchFood(Request request) async {
    final search = request.query("text");
    
   final searchFoods = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id")
        .where("food.name", "like", "%$search%")
        .select([
      "food.id",
      "food.name",
      "food.price",
      "food.image",
      "food.description",
      "food.view",
      "food.category_id",
      "category.category_name",
    ]).get();

    return Response.json(searchFoods);
  }

  Future<Response> increaseViewFood(int id) async {
    final singleFood = await Food()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (singleFood == null) {
      return Response.json({
        "message": "food not found",
      }, HttpStatus.notFound);
    }

    await await Food()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .update({
      "view": (singleFood["view"] == null) ? 1 : singleFood["view"] + 1
    });

    return Response.json({
      "message" : "view updated"
    });
  }

  Future<Response> show(int id) async {
    final singleFood = await Food()
        .query()
        .whereNull("food.deleted_at")
        .join("category", "category.id", "=", "food.category_id")
        .where("food.id", "=", id)
        .select([
      "food.id",
      "food.name",
      "food.price",
      "food.image",
      "food.description",
      "food.view",
      "food.category_id",
      "category.category_name",
    ]).first();

    return Response.json(singleFood);
  }

  Future<Response> update(Request request, int id) async {
    final singleFood = await Food()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (singleFood == null) {
      return Response.json({
        "message": "food not found",
      }, HttpStatus.notFound);
    }
    RequestFile? image = request.input("image");
    String? imagePath;
    if (image != null) {
      imagePath =
          await image.move(path: publicPath("food"), filename: image.filename);
    }

    await Food().query().where("id", "=", id).whereNull("deleted_at").update({
      "name": request.input("name") ?? singleFood["name"],
      "price": request.input("price") ?? singleFood["price"],
      "description": request.input("description") ?? singleFood["description"],
      "updated_at": DateTime.now(),
      "image": imagePath ?? singleFood["image"]
    });

    return Response.json({"message": "food updated!"});
  }

  Future<Response> destroy(int id) async {
    final singleFood = await Food()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (singleFood == null) {
      return Response.json({
        "message": "food not found",
      }, HttpStatus.notFound);
    }

    await Food().query().where("id", "=", id).whereNull("deleted_at").update({
      "deleted_at": DateTime.now(),
    });
    return Response.json({"message": "food deleted!"});
  }
}

final FoodController foodController = FoodController();
