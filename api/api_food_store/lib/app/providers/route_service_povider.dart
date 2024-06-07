import 'package:vania/vania.dart';
import 'package:api_food_store/route/api_route.dart';
import 'package:api_food_store/route/web.dart';
import 'package:api_food_store/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}
