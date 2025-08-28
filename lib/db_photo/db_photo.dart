
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photo_production/db_photo/photo_entity.dart';
import 'package:sqflite/sqflite.dart';

class DBPhoto extends GetxService {
  late Database dbBase;

  Future<DBPhoto> init() async {
    await createPhotoDB();
    return this;
  }

  createPhotoDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'photo.db');

    dbBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await createPhotoTable(db);
        });
  }

  createPhotoTable(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS photo (id INTEGER PRIMARY KEY, createdTime TEXT, image BLOB)');
  }

  insertPhoto(PhotoEntity entity) async {
    final id = await dbBase.insert('photo', {
      'createdTime': entity.createdTime.toIso8601String(),
      'image': entity.image,
    });
    return id;
  }

  cleanPhotoData() async {
    await dbBase.delete('photo');
  }

  Future<List<PhotoEntity>> getPhotoAllData() async {
    var result = await dbBase.query('photo', orderBy: 'createdTime DESC');
    return result.map((e) => PhotoEntity.fromJson(e)).toList();
  }
}
