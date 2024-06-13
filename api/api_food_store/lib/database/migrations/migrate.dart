import 'dart:io';
import 'package:vania/vania.dart';
import 'create_user_table.dart';
import 'create_personal_access_tokens_table.dart';
import '2024_06_13_141625_create_category_table.dart';

void main() async {
  await Migrate().registry();
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await MigrationConnection().setup();
    await CreateUserTable().up();
    await CreatePersonalAccessTokensTable().up();
    await CreateCategoryTable().up();
  }
}
