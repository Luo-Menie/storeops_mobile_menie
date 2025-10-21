

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storeops_mobile/data/models/enrich_firebase_model.dart';

class EventsFirebaseModel {
  final String customerName;
  final String deviceId;
  final String deviceModel;
  final String doorName;
  final List<EnrichFirebaseModel> enrich;
  final String eventId;
  final String groupId;
  final String mediaLink;
  final bool silent;
  final String storeName;
  final Timestamp timestamp;
  final String? uuid;
  final String technology;
  



  factory EventsFirebaseModel.fromMap(Map<String, dynamic> data) {
    var enrichData = data['enriched'] as List<dynamic>? ?? [];
    var enrichDataList = enrichData
        .map((p) => EnrichFirebaseModel.fromMap(Map<String, dynamic>.from(p)))
        .toList();

    return EventsFirebaseModel(
      customerName: data['customerName'] ?? '',
      deviceId: data['deviceId'] ?? '',
      deviceModel: data['deviceModel'] ?? '',
      doorName: data['doorName'] ?? '',
      eventId: data['eventId'] ?? '',
      groupId: data['groupId'] ?? '',
      mediaLink: data['mediaLink'] ?? '',
      silent: data['silent'] == 1 ? true : false,
      storeName: data['storeName'] ?? '',
      timestamp: data['timestamp'] is int
      ? Timestamp.fromMillisecondsSinceEpoch(data['timestamp'])
      : data['timestamp'] as Timestamp,
      uuid: data['uuid'] ?? '',
      enrich: enrichDataList,
      technology: data["technology"] ?? ''
    );
  }

  EventsFirebaseModel({required this.customerName, required this.deviceId, required this.deviceModel, required this.doorName, required this.enrich, required this.eventId, required this.groupId, required this.mediaLink, required this.silent, required this.storeName, required this.timestamp, required this.uuid, required this.technology});

   Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'deviceId': deviceId,
      'deviceModel': deviceModel,
      'doorName': doorName,
      'eventId': eventId,
      'groupId': groupId,
      'mediaLink': mediaLink,
      'silent': silent,
      'storeName': storeName,
      'timestamp': timestamp,
      'uuid': uuid,
      'enrich': enrich,
      'technology': technology
    };
  }

}
