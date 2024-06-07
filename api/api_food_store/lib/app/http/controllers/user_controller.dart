import 'dart:io';

import 'package:api_food_store/app/models/user.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  //! register
  Future<Response> register(Request request) async {
    request.validate({
      "user_name": "required",
      "password": "required",
      "email": "required"
    }, {
      "user_name.required": "user name is required",
      "password.required": "password is required",
      "email.required": "email is required"
    });

    final user = await User()
        .query()
        .where("email", "=", request.input("email"))
        .whereNull("deleted_at")
        .first();

    if (user != null) {
      return Response.json(
          {"message": "email already exists"}, HttpStatus.badRequest);
    }

    RequestFile? avatar = request.file("avatar");
    String? avatarPath;

    if (avatar != null) {
      avatarPath = await avatar.move(
          path: publicPath("avatar"), filename: avatar.filename);
    }

    User().query().insert({
      "user_name": request.input("user_name"),
      "email": request.input("email"),
      "avatar": avatarPath,
      "password": Hash().make(request.input("password").toString()),
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    });

    return Response.json({"message": "register success"}, HttpStatus.created);
  }

  //! login
  Future<Response> login(Request request) async {
    request.validate({
      "password": "required",
      "email": "required"
    }, {
      "password.required": "password is required",
      "email.required": "email is required"
    });

    final user = await User()
        .query()
        .where("email", "=", request.input("email"))
        .whereNull("deleted_at")
        .first();
    if (user == null) {
      return Response.json({"message": "user not found"}, HttpStatus.notFound);
    }

    final password = request.input("password").toString();

    if (!Hash().verify(password, user["password"])) {
      return Response.json(
          {"message": "password not match"}, HttpStatus.unauthorized);
    }

    final token = await Auth()
        .login(user)
        .createToken(expiresIn: Duration(days: 1), withRefreshToken: true);

    return Response.json(token);
  }

//! show single

  Future<Response> show(int id) async {
    final user = await User()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .select([
      "id",
      "user_name",
      "email",
      "avatar",
      "created_at",
      "updated_at",
      "deleted_at",
    ]).first();
    if (user == null) {
      return Response.json({"message": "user not found"}, HttpStatus.notFound);
    }

    return Response.json(user);
  }

//! update
  Future<Response> update(Request request, int id) async {
    final user = await User()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .first();
    if (user == null) {
      return Response.json({"message": "user not found"}, HttpStatus.notFound);
    }

    RequestFile? avatar = request.file("avatar");
    String? avatarPath;

    if (avatar != null) {
      avatarPath = await avatar.move(
          path: publicPath("avatar"), filename: avatar.filename);
    }

    await User().query().where("id", "=", id).whereNull("deleted_at").update({
      "user_name": request.input("user_name") ?? user["user_name"],
      "email": request.input("email") ?? user["email"],
      "avatar": avatarPath ?? user["avatar"],
      "updated_at": DateTime.now(),
    });

    return Response.json({"message": "user Updated !"});
  }


//! delete
  Future<Response> destroy(int id) async {
    //? hard delete
    // await User().query().delete(id);

    //? soft delete
    await User()
        .query()
        .where("id", "=", id)
        .whereNull("deleted_at")
        .update({"deleted_at": DateTime.now()});

    return Response.json({"message": "user Deleted !"});
  }
}

final UserController userController = UserController();
