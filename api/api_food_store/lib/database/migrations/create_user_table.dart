import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTable('users', () {
      id();
      string("user_name" , nullable: false);
      string("email" , nullable: false);
      string("password" , nullable: false);
      string("avatar" , nullable: true);


      timeStamp("created_at",nullable: true);
      timeStamp("updated_at",nullable: true);
      timeStamp("deleted_at",nullable: true);
    });
  }

    @override
  Future<void> down() async{
    super.down();
    await dropIfExists('users');
  }
}
