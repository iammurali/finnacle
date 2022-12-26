import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE spendings(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        spent_on TEXT,
        description TEXT,
        spending_type INTEGER,
        amount FLOAT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> deletetable(sql.Database database) async {
    await database.execute("DROP TABLE IF EXISTS spendings");
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    // sql.deleteDatabase('finance_journal_v1.db');
    // sql.deleteDatabase('finance_journal.db');
    return sql.openDatabase(
      'finance_journal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String spentOn, String? descrption,
      int spendingType, double amount) async {
    final db = await SQLHelper.db();

    final data = {
      'amount': amount,
      'spent_on': spentOn,
      'description': descrption,
      'spending_type': spendingType
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
