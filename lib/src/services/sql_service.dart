import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:wecode_2021/src/sql_plat/sql_data_models.dart';

class SqlDataBaseHelper {
// 1
  static const _databaseName = 'MyRecipes.db';
  static const _databaseVersion = 1;

// 2
  static const recipeTable = 'Recipe';
  static const ingredientTable = 'Ingredient';
  static const recipeId = 'recipeId';
  static const ingredientId = 'ingredientId';

// 3
  static late BriteDatabase _streamDatabase;

// make this a singleton class
// 4
  SqlDataBaseHelper._privateConstructor();
  static final SqlDataBaseHelper instance =
      SqlDataBaseHelper._privateConstructor();
// 5
  static var lock = Lock();

// only have a single app-wide reference to the database
// 6
  static Database? _database;

// TODO: Add create database code here

// SQL code to create the database table
// 1
  Future _onCreate(Database db, int version) async {
    // 2
    await db.execute('''
        CREATE TABLE $recipeTable (
          $recipeId INTEGER PRIMARY KEY,
          label TEXT,
          image TEXT,
          url TEXT,
          calories REAL,
          totalWeight REAL,
          totalTime REAL
        )
        ''');
    // 3
    await db.execute('''
        CREATE TABLE $ingredientTable (
          $ingredientId INTEGER PRIMARY KEY,
          $recipeId INTEGER,
          name TEXT,
          weight REAL
        )
        ''');
  }

// TODO: Add code to open database
// this opens the database (and creates it if it doesn't exist)
// 1
  Future<Database> _initDatabase() async {
    // 2
    final documentsDirectory = await getApplicationDocumentsDirectory();

    // 3
    final path = join(documentsDirectory.path, _databaseName);

    // 4
    // TODO: Remember to turn off debugging before deploying app to store(s).
    Sqflite.setDebugModeOn(true);

    // 5
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

// TODO: Add initialize getter here

// 1
  Future<Database> get database async {
    // 2
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data
    // 3
    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is accessed
      // 4
      if (_database == null) {
        // 5
        _database = await _initDatabase();
        // 6
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

// 1
  Future<BriteDatabase> get streamDatabase async {
    // 2
    await database;
    return _streamDatabase;
  }

  List<Recipe> parseRecipes(List<Map<String, dynamic>> recipeList) {
    final recipes = <Recipe>[];
    // 1
    recipeList.forEach((recipeMap) {
      // 2
      final recipe = Recipe.fromJson(recipeMap);
      // 3
      recipes.add(recipe);
    });
    // 4
    return recipes;
  }

  Future<List<Recipe>> findAllRecipes() async {
    // 1
    final db = await instance.streamDatabase;
    // 2
    final recipeList = await db.query(recipeTable);
    // 3
    final recipes = parseRecipes(recipeList);
    return recipes;
  }

  Stream<List<Recipe>> watchAllRecipes() async* {
    final db = await instance.streamDatabase;
    // 1
    yield* db
        // 2
        .createQuery(recipeTable)
        // 3
        .mapToList((row) => Recipe.fromJson(row));
  }

  Future<Recipe> findRecipeById(int id) async {
    final db = await instance.streamDatabase;
    final recipeList = await db.query(recipeTable, where: 'id = $id');
    final recipes = parseRecipes(recipeList);
    return recipes.first;
  }

  // 1
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    // 2
    return db.insert(table, row);
  }

  Future<int> insertRecipe(Recipe recipe) {
    // 3
    return insert(recipeTable, recipe.toJson());
  }

// 1
  Future<int> _delete(String table, String columnId, int id) async {
    final db = await instance.streamDatabase;
    // 2
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(Recipe recipe) async {
    // 3
    if (recipe.id != null) {
      return _delete(recipeTable, recipeId, recipe.id!);
    } else {
      return Future.value(-1);
    }
  }

  void close() {
    _streamDatabase.close();
  }
}
