import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/data/models/events_firebase_model.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class ReportsSoldScreen extends StatefulWidget {
  static const name = 'reports_sold_screen';
  const ReportsSoldScreen({super.key});

  @override
  State<ReportsSoldScreen> createState() => _ReportsSoldScreenState();
}

class _ReportsSoldScreenState extends State<ReportsSoldScreen> {
  bool isLoadingEvents= false;
  String accountId= '';
  String storeId= '';
  String storeName= '';
  String tokenMobile= '';
  String groupSelected= '';
  String groupIdSelected= '';
  List<EventsFirebaseModel>? eventsList;
  int totalSales=0;
  List<String> categories=[];
  List<dynamic> categoriesData=[];

   @override
  void initState() {
    super.initState();
    getCustomerInfo();
  }


Future<void> getCustomerInfo() async {
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
    .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
    .where('timestamp', isLessThan: endOfDay)
    .get();

     final items = snapshot.docs
    .map((doc) => EventsFirebaseModel.fromMap(doc.data()))
    .toList();
    
    

    List<EventsFirebaseModel> eventsFiltered = [];
     
    if(groupIdSelected=="0"){ 
      eventsFiltered= items
      .where((e) => e.eventId == "rfid_sale")
      .toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    else{
      eventsFiltered= items
      .where((e) => e.eventId == "rfid_sale")
      .where((e) => e.groupId == groupIdSelected)
      .toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    totalSales= eventsFiltered.length;

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
              flex: 2,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.sold_report, 
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppTheme.primaryColor
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
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
                                  child: Text(AppLocalizations.of(context)!.total_sales,
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
                                  child: Text(totalSales.toString(), 
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
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 15),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shadowColor: AppTheme.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children:[
                        Text(AppLocalizations.of(context)!.total_sales_category),
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
                ),
              ),
            )
          ],
        )
      ),
      
        
      );    
  }
}