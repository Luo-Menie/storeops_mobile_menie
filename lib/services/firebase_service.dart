
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
class FirebaseService {

  static final FirebaseService instance = FirebaseService._init();
  FirebaseService._init();

  static Future<void> insertTokenMobile(String accountNumber, String storeId, String token, bool allowPushNotifications, bool soldNotifications) async {
    await firestore.collection('mobile_tokens').add({
      'accountNumber': accountNumber,
      'storeId': storeId,
      'token': token,
      'pushNotifications': allowPushNotifications,
      'soldNotifications': soldNotifications
    });
  }

  static Future<String> tokenMobileExists(String token) async {
      QuerySnapshot<Map<String, dynamic>>? snapshot;
      
      snapshot = await FirebaseFirestore.instance
      .collection('mobile_tokens')
      .where('token', isEqualTo: token)
      .get();
      
      
      if(snapshot.size>0){
        String docId= snapshot.docs.first.id; 
        return docId;
      }
      else {
        return '';
      }
  }

  static Future<void> updateInfoTokenMobile(String accountNumber, String storeId, String docId, bool allowPushNotifications, bool soldNotifications) async {
      await FirebaseFirestore.instance
        .collection('mobile_tokens')
        .doc(docId)
        .update({
          'accountNumber': accountNumber,
          'storeId': storeId,
          'pushNotifications': allowPushNotifications,
          'soldNotifications': soldNotifications
        });
  }
}