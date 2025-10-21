

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';
import 'package:storeops_mobile/data/models/enrich_firebase_model.dart';

class DbHelper {

  final eventsTable = intMapStoreFactory.store("events");
  final enrichTable = intMapStoreFactory.store("enrich");

  Database? db;
  Future<Database> openDataBase() async {
    if (db == null) {
      final dir = await getApplicationDocumentsDirectory(); 
      final dbPath = join(dir.path, "storeops_database.db");
      db = await databaseFactoryIo.openDatabase(dbPath);
    }
      return db!;
  }

  Future<void> deleteEvents() async{
    final db = await openDataBase();
    await eventsTable.delete(db);
  }


  Future<void> saveEvent(String uuid, String accountNumber, String storeId, String customerName,String eventType, bool silence, int timestamp, List<EnrichFirebaseModel> enrich ) async {
    final db = await openDataBase();

    await eventsTable.add(db, {
      "uuid":uuid,
      "accountNumber": accountNumber, 
      "storeId": storeId,
      "customerName": customerName,
      "event_type":eventType,
      "silence":silence,
      "timestamp": timestamp
      }
    );

    for(var itemEnrich in enrich){
      await enrichTable.add(db, {
        "uuid":uuid,
        "category": itemEnrich.category, 
        "description": itemEnrich.description,
        "epc": itemEnrich.epc,
        "gtin":itemEnrich.gtin,
        "imageUrl":itemEnrich.imageUrl,
        "price": itemEnrich.price,
        "sku": itemEnrich.sku
      }
      );
    }
  }

  Future<List<Map<String, dynamic>>> getEventsToday() async {
    final db = await openDataBase();
    

    // final records = await events_table.find(db, finder: finder);
    final records = await eventsTable.find(db);
    
    return records.map((record) => record.value as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getEnrichData(String uuid) async {
    final db = await openDataBase();
    
    final finder = Finder(
      filter: Filter.and([
        Filter.equals('uuid', uuid),
      ])
    );

    final records = await enrichTable.find(db, finder: finder);
    
    return records.map((record) => record.value as Map<String, dynamic>).toList();
  }
}