import 'package:vania/vania.dart';

class CreateFoodTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('food', () {
      id();
      string("name",nullable: false);
      string("price",nullable: false);
      string("image",nullable: true);
      string("description",nullable: true);

      bigInt("view",nullable: true);
      bigInt("category_id",nullable: false,unsigned: true);

      timeStamp("created_at", nullable: true);
      timeStamp("updated_at", nullable: true);
      timeStamp("deleted_at", nullable: true);

      foreign("category_id", "category", "id");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('food');
  }
}
