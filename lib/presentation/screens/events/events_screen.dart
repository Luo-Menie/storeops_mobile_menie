import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/data/models/events_firebase_model.dart';
import 'package:storeops_mobile/db/db_sqlite_helper.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_event_item.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_event_rf_item.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/custom_expand_event.dart';
import 'package:storeops_mobile/presentation/screens/events/widgets/header_item_report.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class EventsScreen extends StatefulWidget {
  static const name='events_screen';

  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}



class _EventsScreenState extends State<EventsScreen> {
  String? accountId;
  String? storeId;
  String? storeName;
  String? tokenMobile='';
  bool? soldSelected;
  bool? rfSelected;
  bool? rfidSelected;
  bool isLoadingEvents = false;
  String? groupIdSelected= '';
  String? groupSelected= '';

  final Set<String> knownIds = {};
  final ValueNotifier<Set<String>> flashIdsNotifier = ValueNotifier({});
  bool isFirstLoad = true;

  late DateTime startOfDay;
  late DateTime endOfDay;
  List<Map<String, dynamic>> eventsList = [];

  StreamSubscription? eventsSub;

  final db = DbSqliteHelper.instance;
  final Set<String> flashIds = {};

  @override
  void initState() {
    super.initState();
    startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    endOfDay = startOfDay.add(const Duration(days: 1));
    getCustomerInfo();
  }

  Future<void> getCustomerInfo() async {
    final accountCode = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerCodeSelected);
    final store = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);
    final storeN = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    final soldSelec = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.soldSelected);
    final rfSelec = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfSelected);
    final rfidSelec = await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfidSelected);
    final tokenM = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    final groupSelec = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupSelected);
    final groupIdSelec = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupIdSelected);

    setState(() {
      accountId = accountCode;
      storeId = store;
      storeName = storeN;
      soldSelected = soldSelec;
      tokenMobile= tokenM;
      rfSelected= rfSelec;
      rfidSelected= rfidSelec;
      groupSelected= groupSelec;
      groupIdSelected= groupIdSelec;
    });

    subscribeToEvents(startOfDay,endOfDay);
  }

  void subscribeToEvents(DateTime startDate, DateTime endDate) {
    eventsSub?.cancel();

    setState(() => isLoadingEvents = true);

    eventsSub = FirebaseFirestore.instance
        .collection('events')
        .doc(accountId)
        .collection(storeId!)
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp', isLessThan: endDate)
        .snapshots()
        .listen((snapshot) async {
          final docsFiltered = (snapshot.docs
          .where((e) => e["eventId"] == "rfid_alarm" || e["eventId"] == "rfid_sale" || 
          e["eventId"] == "rfid_forgotten" || e["technology"] == "rf")
          .toList()
          ..sort((a, b) => b["timestamp"].compareTo(a["timestamp"]))).toList();

      
          for (final doc in docsFiltered) {
            final model = EventsFirebaseModel.fromMap(doc.data());
            await db.saveEvents(
              {
                "uuid": model.uuid,
                "accountNumber": accountId,
                "storeId": storeId,
                "eventId": model.eventId,
                "silent": model.silent ? 1 : 0,
                "groupId": model.groupId,
                "timestamp": model.timestamp.toDate().millisecondsSinceEpoch,
                "deviceId": model.deviceId,
                "deviceModel": model.deviceModel,
                "technology": model.technology
              },
              model.enrich,
            );
          }

        final itemsDb = await db.getEventsByDate(soldSelected!, rfSelected!, rfidSelected!, startDate, endDate, groupIdSelected!);
        final enrichedEvents = await Future.wait(itemsDb.map((doc) async {
          final enrich = await db.getEnrichData(doc["idEvent"], doc["uuid"]);
          return {...doc, "enrich": enrich};
        }));

      showNewEventColor(enrichedEvents);

      setState(() {
        eventsList = enrichedEvents;
        isLoadingEvents = false;
      });
    });
  }
 
  void showNewEventColor(List<Map<String, dynamic>> docs) {
  if (isFirstLoad) {
    for (final doc in docs) {
      knownIds.add(doc["idEvent"].toString());
    }
    isFirstLoad = false;
    return;
  }

  final newFlashes = <String>{};
  for (final doc in docs) {
    final id = doc["idEvent"].toString();
    if (!knownIds.contains(id)) {
      knownIds.add(id);
      newFlashes.add(id);

      Future.delayed(const Duration(seconds: 2), () {
        flashIdsNotifier.value = Set.from(flashIdsNotifier.value)..remove(id);
      });
    }
  }

  if (newFlashes.isNotEmpty) {
    flashIdsNotifier.value = Set.from(flashIdsNotifier.value)..addAll(newFlashes);
  }
}

  @override
  void dispose() {
    eventsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),
      // floatingActionButton: CustomFabButton(
      //   icon: Icons.filter_list,
      //   onPressed: () => showFilterButtons(context),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: CustomAppbar(includeBottomBar: false, tokenMob: tokenMobile!),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      body: isLoadingEvents
          ? CustomLoaderScreen(message: '${AppLocalizations.of(context)!.loading_events} $storeName')
          : showEventsList(eventsList),
    );
  }

  Widget showEventsList(List<Map<String, dynamic>> docs) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeaderItemReport(icon: Icons.my_library_books_outlined, textHeader: AppLocalizations.of(context)!.total, valueHeader: docs.length.toString()),
                  HeaderItemReport(icon: Icons.store_mall_directory_outlined, textHeader: AppLocalizations.of(context)!.site, valueHeader: '$storeId-$storeName'),
                  HeaderItemReport(icon: Icons.settings_backup_restore_rounded, textHeader: AppLocalizations.of(context)!.group, valueHeader: groupSelected!)
                ],
              ),
              const SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,

              //   children: [
              //     Text(AppLocalizations.of(context)!.events_from, style: 
              //       TextStyle(
              //         fontSize: 11,
              //         fontWeight: FontWeight.w500
              //       ),
              //     ),
              //     Text(DateFormat('dd/MM/yyyy').format(startOfDay), style: 
              //       TextStyle(
              //         fontSize: 11,
              //         fontWeight: FontWeight.w700
              //       ),
              //     ),
              //     SizedBox(width: 7),
              //     Text(AppLocalizations.of(context)!.to, style: 
              //       TextStyle(
              //         fontSize: 11,
              //         fontWeight: FontWeight.w500
              //       ),
              //     ),
              //     Text(DateFormat('dd/MM/yyyy').format(endOfDay.add(Duration(days: -1))), style: 
              //       TextStyle(
              //         fontSize: 11,
              //         fontWeight: FontWeight.w700
              //       ),
              //     ),
                  
              //   ],
              // ),
              Divider(color: AppTheme.buttonsColor, thickness: 1),
              
              
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ValueListenableBuilder<Set<String>>(
              valueListenable: flashIdsNotifier,
              builder: (context, flashIds, _) {
                return ListView.builder(
                  key: const PageStorageKey('events_list'),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final event = doc["enrich"] as List<Map<String, dynamic>>;

                    final id = doc["idEvent"];
                    final shouldFlash = flashIds.contains(doc["idEvent"].toString());
                    
                    return 
                      TweenAnimationBuilder<Color?>(
                        key: ValueKey('$id-$shouldFlash'),
                        tween: ColorTween(
                          begin: shouldFlash  ? AppTheme.primaryColor : Colors.transparent,
                          end: Colors.transparent,
                        ),
                        duration: const Duration(seconds: 2),
                        builder: (context, color, child) {
                          return Container(
                            color: color,
                            child: child,
                          );
                        },
                        child:
                          //rfid alarm, rfid forgotten, rfid sale
                          doc["eventId"]== "rfid_alarm" || doc["eventId"] == "rfid_sale" ?
                          event.length == 1 ? 
                          CustomEventItem(
                            timestamp: DateTime.fromMillisecondsSinceEpoch(doc["timestamp"]).toLocal().toString(),
                            article: event[0]["description"],
                            epc: event[0]["epc"],
                            groupId: doc["groupId"],
                            urlImage: event[0]["imageUrl"],
                            silent: doc["silent"] == 1,
                            storeSelected: storeId.toString(),
                            storeName: storeName!,
                            gtin: event[0]["gtin"],
                            eventId: doc["eventId"],
                            technology: doc["technology"],
                          )
                          : 
                          CustomExpandEvent(
                            timestamp: DateTime.fromMillisecondsSinceEpoch(doc["timestamp"]).toLocal().toString(),
                            groupId: doc["groupId"],
                            enrich: event,
                            silent: doc["silent"] == 1,
                            storeSelected: storeId.toString(),
                            storeName: storeName!,
                            eventId: doc["eventId"],
                            technology: doc["technology"]
                          )
                          
                          //rf events
                          : 
                          CustomEventRfItem(
                            timestamp: DateTime.fromMillisecondsSinceEpoch(doc["timestamp"]).toLocal().toString(),
                            groupId: doc["groupId"],
                            silent: doc["silent"] == 1,
                            storeSelected: storeId.toString(),
                            storeName: storeName!,
                            eventId: doc["eventId"],
                            deviceId: doc["deviceId"],
                            deviceName: doc["deviceModel"],
                            groupName: "",
                            technology: doc["technology"],
                          )
                      );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void showFilterButtons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.topLeft,
          height: 250,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.filter_events,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      backgroundColor: AppTheme.secondaryColor,
                      iconColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                        endOfDay = startOfDay.add(Duration(days: 1));

                        knownIds.clear();
                        flashIdsNotifier.value = {};
                        isFirstLoad = true;
                        subscribeToEvents(startOfDay,endOfDay);
                      });
                    },
                    icon: Icon(Icons.today_outlined, size: 22),
                    label: Text(
                      AppLocalizations.of(context)!.today,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      backgroundColor: AppTheme.secondaryColor,
                      iconColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showDateRangePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime.now(),
                      ).then((DateTimeRange? value) {
                        if (value != null) {
                          setState(() {
                            startOfDay = value.start;
                            endOfDay = value.end.add(Duration(days: 1));

                            if (startOfDay.isAfter(endOfDay)) {
                              endOfDay = startOfDay.add(Duration(days: 1));
                            }

                            knownIds.clear();
                            flashIdsNotifier.value = {};
                            isFirstLoad = true;

                            subscribeToEvents(startOfDay,endOfDay);
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.calendar_month_outlined, size: 22),
                    label: Text(
                      AppLocalizations.of(context)!.date_range,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}