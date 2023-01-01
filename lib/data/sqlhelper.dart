import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> _updateTableSpendingsV1toV2(sql.Database database) async {
    await database.execute('ALTER TABLE spendings ADD trackingType TEXT');
    await database.execute('ALTER TABLE spendings ADD trackingStatus TEXT');
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE spendings(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        spent_on TEXT,
        description TEXT,
        spending_type INTEGER,
        amount FLOAT,
        trackingType TEXT,
        trackingStatus TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> deletetable(sql.Database database) async {
    await database.execute("DROP TABLE IF EXISTS spendings");
  }

  static Future<sql.Database> db() async {
    // sql.deleteDatabase('finance_journal_v1.db');
    // sql.deleteDatabase('finance_journal.db');
    return sql.openDatabase('finance_journal.db', version: 2,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 1) {
        _updateTableSpendingsV1toV2(db);
      }
    }, onDowngrade: sql.onDatabaseDowngradeDelete);
  }

  // Create new item (journal)
  static Future<int> createItem(String spentOn, String? descrption,
      int spendingType, double amount, trackingType) async {
    print('expensetracking type: ' + trackingType);
    final db = await SQLHelper.db();

    final data = {
      'amount': amount,
      'spent_on': spentOn,
      'description': descrption,
      'spending_type': spendingType,
      'trackingType': trackingType
    };
    final id = await db.insert('spendings', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all spendings (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('spendings', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getCountBasedOn(
      String columnName) async {
    final db = await SQLHelper.db();
    return db.rawQuery(
        "SELECT $columnName, SUM(amount) AS 'num' FROM spendings GROUP BY $columnName");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('spendings', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String spentOn, String? descrption,
      Int spendingType, double amount) async {
    final db = await SQLHelper.db();

    final data = {
      'amount': amount,
      'spent_on': spentOn,
      'description': descrption,
      'spending_type': spendingType
    };

    final result =
        await db.update('spendings', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("spendings", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
