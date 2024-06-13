import 'package:vania/vania.dart';

class CreateCategoryTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('category', () {
      id();
      //! join food
      // string("name");
      string("category_name",nullable: false);

      timeStamp("created_at", nullable: true);
      timeStamp("updated_at", nullable: true);
      timeStamp("deleted_at", nullable: true);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('category');
  }
}
