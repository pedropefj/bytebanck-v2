import 'package:bytebank_v2/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'bytebank.db');
    debugPrint(dbPath);
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE contacts('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'account_number INTEGER)');
    }, version: 1);
  });
}

Future<int> save(Contact contact) {
  return createDatabase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  });
}

Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((contactsMap) {
      final List<Contact> contacts = [];
      for (Map<String, dynamic> contactMap in contactsMap) {
        final Contact contact = Contact(
          id: contactMap['id'],
          name: contactMap['name'],
          accountNumber: contactMap['account_number'],
        );
        contacts.add(contact);
      }
      return contacts;
    });
  });
}
