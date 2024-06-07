import 'package:api_food_store/app/http/controllers/user_controller.dart';
import 'package:api_food_store/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api/v1');

    Router.post("register", userController.register);
    Router.post("login", userController.login);

    Router.group((){
      Router.get("{id}", userController.show);
      Router.put("{id}", userController.update);
      Router.delete("{id}", userController.destroy);
    },
    prefix: "user",
    middleware: [  AuthenticateMiddleware()]
    );

  }
}
