import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/data/models/events_firebase_model.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/presentation/screens/reports/widgets/custom_button_filter.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class ReportsScreen extends StatefulWidget {
  static const name='reports_screen';
  
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isLoadingEvents= false;
  String accountId= '';
  String storeId= '';
  String storeName= '';
  String tokenMobile= '';
  String groupSelected= '';
  String groupIdSelected= '';
  List<EventsFirebaseModel>? eventsList;
  int totalAlarms=0;
  int totalAudibleAlarms=0;
  double avgAlarms=0;
  int avgAlarmsTotal=0;
  List<String> categories=[];
  List<dynamic> categoriesData=[];
  bool buttonRFIDActive= true;
  bool buttonRFActive= false;
  String filter="";

   @override
  void initState() {
    super.initState();
    getCustomerInfo();
  }

  Future<void> getCustomerInfo() async {
    setState(() => isLoadingEvents = true);
    final accountCode= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerCodeSelected);
    final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);
    final storeN= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    final tokenM= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    final groupIdSelec= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupIdSelected);
    final groupSelec= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupSelected);
    setState(() {
      accountId= accountCode!;
      storeId= store!;
      storeName= storeN!;
      tokenMobile= tokenM!;
      groupIdSelected= groupIdSelec!;
      groupSelected= groupSelec!;
      filter= "rfid_alarm";
      getReportData();

    });
  }

   Future<List<EventsFirebaseModel>> getReportData() async {
    setState(() => isLoadingEvents = true);
    
    
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    
    
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    snapshot = await FirebaseFirestore.instance
    .collection('events')
    .doc(accountId)
    .collection(storeId)
    .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
    .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
    .get();

    
    List<EventsFirebaseModel> items =[]; 
    
    if(filter=="rf"){  
      if(groupIdSelected=="0"){
        items= snapshot.docs
        .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
        .where((e) => e.technology == filter)
        .toList();
      }
      else{
        items= snapshot.docs
        .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
        .where((e) => e.technology == filter)
        .where((e) => e.groupId == groupIdSelected)
        .toList();
      }
    }
    //rfid
    else{
      if(groupIdSelected=="0"){
        items= snapshot.docs
        .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
        .where((e) => e.eventId == filter)
        .toList();
      }
      else{
        items= snapshot.docs
        .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
        .where((e) => e.eventId == filter)
        .where((e) => e.groupId == groupIdSelected)
        .toList();
      }
    }
    
    

    List<EventsFirebaseModel> eventsFiltered = [];
    
    if(filter=="rf"){
      eventsFiltered= items
      .where((e) => e.technology == filter)
      .toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    else{
      eventsFiltered= items
      .where((e) => e.eventId == filter)
      .toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    

    final audibleAlarms= eventsFiltered
    .where((e) => e.silent == false).toList();
    
    totalAlarms= eventsFiltered.length;
    totalAudibleAlarms= audibleAlarms.length;
    avgAlarms= ((totalAlarms+totalAudibleAlarms)/2);
    avgAlarmsTotal= avgAlarms.round();
    

    for (var item in eventsFiltered){
      for(var itemEnrich in item.enrich){
        if(!categories.contains(itemEnrich.category)){
          categories.add(itemEnrich.category);
        }
      }
    }

    for(var category in categories){
      int categoryCount=0;
      for (var item in eventsFiltered){
        for(var itemEnrich in item.enrich){
          if(itemEnrich.category==category){
            categoryCount++;
          }
        }
      }
      final itemCat={category:categoryCount};
      categoriesData.add(itemCat);
    }


    setState(() {
      eventsList= items;
      isLoadingEvents= false;
    });

    return items;
  }



  @override
  Widget build(BuildContext context) {
    final scaffoldKey= GlobalKey<ScaffoldState>();
  

    return 
        Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(includeBottomBar: false, tokenMob: tokenMobile),
      
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        bottomNavigationBar: CustomBottomAppbar(),
        body: isLoadingEvents ? CustomLoaderScreen(message: AppLocalizations.of(context)!.loading_report) : Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: 
                Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      CustomButtonFilter(icon: Icons.wifi_tethering, text: 'RFID', active: buttonRFIDActive, onPressed: () {
                        setState(() {
                          buttonRFIDActive= true;
                          buttonRFActive= false;
                          filter='rfid_alarm';
                          categoriesData=[];
                          getReportData();
                        });
                      },),
                      CustomButtonFilter(icon: Icons.rss_feed, text: 'RF', active: buttonRFActive, onPressed: () {
                        setState(() {
                          buttonRFActive= true;
                          buttonRFIDActive= false;
                          filter='rf';
                          categoriesData=[];
                          getReportData();
                        });
                      },),
                ]
              )
            ),
            Divider(),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.daily_report, 
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppTheme.primaryColor
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children:[ 
                              Text(AppLocalizations.of(context)!.site, 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                                ),
                              ),
                              Text('$storeId - $storeName', 
                                textAlign: TextAlign.center
                              ),
                            ]
                          )
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children:[ 
                              Text(AppLocalizations.of(context)!.group, 
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18
                                ),
                              ),
                              Text(groupSelected, textAlign: TextAlign.center),
                            ]
                          )
                        )
                      ],
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        shadowColor: AppTheme.primaryColor,
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 2),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Expanded(
                                  flex: 4,
                                  child: Text(AppLocalizations.of(context)!.total_alarms,
                                  textAlign: TextAlign.center, 
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip
                                  )
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(totalAlarms.toString(), 
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ),
                    ),

                    buttonRFIDActive ?
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 1,
                        color: Colors.white,
                        shadowColor: AppTheme.primaryColor,
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 2),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                Expanded(
                                  flex: 4,
                                  child: Text(AppLocalizations.of(context)!.total_audible_alarms,
                                  textAlign: TextAlign.center, 
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip
                                  )
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(totalAudibleAlarms.toString(), 
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  )
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ),
                    ): SizedBox(),
                    
                    
                  ],
                ),
              )
            ),
            
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 15),
                child: 
                buttonRFIDActive ?
                Card(
                  color: Colors.white,
                  elevation: 1,
                  
                  shadowColor: AppTheme.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children:[
                        Text(AppLocalizations.of(context)!.total_audible_alarms_by_category),
                        Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: 
                      
                            GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, 
                                mainAxisSpacing: 3, 
                                crossAxisSpacing: 3,
                              ),
                              padding: EdgeInsets.all(8.0), 
                              itemCount: categoriesData.length, 
                              itemBuilder: (context, index) {
                                final itemCategory= Map.from(categoriesData[index]);
                                return Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  shadowColor: AppTheme.primaryColor,
                                  child: 
                                    Padding(
                                      padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 2),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:[ 
                                            Expanded(
                                              flex: 4,
                                              child: Text(itemCategory.keys.first,
                                                textAlign: TextAlign.center , 
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  overflow: TextOverflow.clip
                                                )
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Text(itemCategory.values.first.toString(), 
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                )
                                              ),
                                            ),
                                          ]
                                        ),
                                      ),
                                    ),
                                );
                              },
                            )
                      
                          ),
                        ),
                      ),
                      ]
                    ),
                  ),
                ): SizedBox(),
              ),
            )
          ],
        )
      ),
      
        
      );    
  }
}