import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/model/contact.dart';

class DBHelper{


  static final DBHelper instance = DBHelper._init();
  DBHelper._init();



  static Database? _database;
  static const String dbName = 'contacts.db';

  Future<Database> get database async{
  if(_database != null){
    return _database!;
  }
  _database = await _initDB(dbName);
  return _database!;

  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);

  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableContact(
    ${ContactFields.id} $idType, 
    ${ContactFields.firstName} $boolType,
    ${ContactFields.lastName} $integerType,
    ${ContactFields.phone} $textType,
    ${ContactFields.email} $textType,
    ${ContactFields.createdTime} $textType,
    ${ContactFields.photo} $textType
    )
    ''');

  }

  Future<Contact> create(Contact contact) async{
    final db = await instance.database;
    final id = await db.insert(tableContact, contact.toJson());
    return contact.copy(id: id);
  }

  Future<Contact> readContact(int id) async{
    final db = await instance.database;
    final maps = await db.query(
        tableContact,
        columns: ContactFields.values,
        where: '${ContactFields.id} = ?',
        whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Contact.fromJson(maps.first);

    }
    else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Contact>> readAllContacts() async{
    final db = await instance.database;
    final result = await db.query(tableContact);
    return result.map((json) => Contact.fromJson(json)).toList();
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return db.delete(tableContact,where: '${ContactFields.id} = ?',whereArgs: [id],);
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

  Future<int> update(Contact contact) async{
    final db = await instance.database;
    
    return db.update(tableContact, contact.toJson(), where: '${ContactFields.id}=?', whereArgs: [contact.id],);
  }


}