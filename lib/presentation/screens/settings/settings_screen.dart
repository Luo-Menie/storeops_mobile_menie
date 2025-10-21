import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/db/db_sqlite_helper.dart';
import 'package:storeops_mobile/domain/entities/customer_response_entity.dart';
import 'package:storeops_mobile/domain/entities/stores_response_entity.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_bottom_appbar.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_fab_button.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_loader_screen.dart';
import 'package:storeops_mobile/presentation/global_widgets/custom_snackbar_message.dart';
import 'package:storeops_mobile/presentation/screens/home/widgets/side_menu.dart';
import 'package:storeops_mobile/presentation/screens/settings/widgets/tech_checkbox.dart';
import 'package:storeops_mobile/presentation/screens/settings/widgets/title_text.dart';
import 'package:storeops_mobile/services/firebase_service.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  static const name = 'settings_screen';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<CustomerResponseEntity> customerList = [];
  CustomerResponseEntity? selectedCustomer;
  bool isLoadingCustomers = false;

  List<StoresResponseEntity> storeList = [];
  StoresResponseEntity? selectedStore;
  Map<String, dynamic>?   selectedGroup;
  bool isLoadingStores = false;
  bool isLoadingGroups = false;
  String? userAuth;

  List<Map<String,dynamic>> valuesToSave=[];
  bool isCheckedSold = false;
  bool isCheckedRFID = true;
  bool isCheckedRF = false;
  bool isCheckedPush = true;
  bool isSavingConfig = false;
  bool storeValidated= false;
  bool isLoadingInfo= false;
  List<Map<String,dynamic>> groupList = [];
  final db = DbSqliteHelper.instance;
  String? tokenMobile;
  

  
  @override
  void initState() {
    super.initState();
    getUserAuth();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCustomers();
      loadTechnologies();
    });
    
  }

   Future<void> getUserAuth() async {
    setState(() {
      isLoadingInfo= true;
    });
    final user= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userAuthenticated);
    final tokenM= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    setState(() {
      userAuth= user;
      tokenMobile= tokenM;
    });
  }

  Future<void> loadCustomers() async {
    setState(() => isLoadingCustomers = true);
    final repo = context.read<CustomerRepository>();
    final customers = await repo.customer();
    final customerSelectedJson= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelectedJson);
    setState(() {
      customerList = customers;
      if (customerSelectedJson != null) {
        final customer = CustomerResponseEntity.fromJson(customerSelectedJson);
        selectedCustomer= customer;
        loadStores(customer.customerToken);
      }
      isLoadingCustomers = false;
      isLoadingInfo= false;
      
    });
  }

  Future<void> loadStores(String customerToken) async {
    setState(() => isLoadingStores = true);
    final repo = context.read<StoresRepository>();
    final stores = await repo.stores(customerToken);
    final storeSelectedJson= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelectedJson);
    
    setState(() {
      storeList = stores;
      selectedStore = null;
      if (storeSelectedJson != null && !storeValidated) {
        final store = StoresResponseEntity.fromJson(storeSelectedJson);
        selectedStore= store;
        storeValidated= true;
        loadGroups(store.groups);
      }
      isLoadingStores = false;
    });
  }

  Future<void> loadGroups(List<dynamic> groups) async {
    setState(() => isLoadingGroups = true);
    final groupSelected= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupSelected);
    final groupIdSelected= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.groupIdSelected);

    setState(() {
      groupList.clear();
      groupList.add({'groupId': '0','groupName': AppLocalizations.of(context)!.all});
      for(var itemGroup in groups){
        groupList.add(itemGroup);
      }
      selectedGroup = null;
      if (groupSelected != null) {
        final group = groupList.firstWhere(
          (g) => g['groupId'].toString() == groupIdSelected,
          orElse: () => groupList.first,
        );
        selectedGroup= group;
      }
      isLoadingGroups = false;
    });
  }

  Future<void> loadTechnologies() async {
    final soldValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.soldSelected);
    final rfValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfSelected);
    final rfidValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.rfidSelected);
    final pushValue= await SharedPreferencesService.getSharedPreferenceBool(SharedPreferencesService.pushSelected);
    
    setState(() {
      
      if (soldValue != null && rfValue != null && rfidValue != null && pushValue != null) {
        isCheckedSold= soldValue;
        isCheckedRF= rfValue;
        isCheckedRFID= rfidValue;
        isCheckedPush= pushValue;
      }
      
    });
  }

  Future<void> saveConfig() async {
    setState(() => isSavingConfig = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final messageSaved= AppLocalizations.of(context)!.config_saved;

    if(selectedCustomer==null){
      scaffoldMessenger.showSnackBar(CustomSnackbarMessage(
        message: AppLocalizations.of(context)!.select_client, 
        color: AppTheme.secondaryColor, 
        paddingVertical: 10) as SnackBar
      );
      isSavingConfig = false;
      await Future.delayed(const Duration(seconds: 2));
      return;
    }
    else{
      if(selectedStore==null){
        scaffoldMessenger.showSnackBar(CustomSnackbarMessage(
          message: AppLocalizations.of(context)!.select_store, 
          color: AppTheme.secondaryColor, 
          paddingVertical: 10) as SnackBar
        );
        isSavingConfig = false;
        await Future.delayed(const Duration(seconds: 2));
        return;
      }
      else{
        if(selectedGroup == null){
          scaffoldMessenger.showSnackBar(CustomSnackbarMessage(
            message: AppLocalizations.of(context)!.select_group, 
            color: AppTheme.secondaryColor, 
            paddingVertical: 10) as SnackBar
          );
          isSavingConfig = false;
          await Future.delayed(const Duration(seconds: 2));
          return;
        }
        else{
          if(!isCheckedSold && !isCheckedRFID && !isCheckedRF){
            scaffoldMessenger.showSnackBar(CustomSnackbarMessage(
            message: AppLocalizations.of(context)!.select_technology, 
            color: AppTheme.secondaryColor, 
            paddingVertical: 10) as SnackBar
          );
            isSavingConfig = false;
            await Future.delayed(const Duration(seconds: 2));
            return;
          }
          else{
            var docId= await FirebaseService.tokenMobileExists(tokenMobile!);
      
            valuesToSave.add({SharedPreferencesService.customerSelected :selectedCustomer?.description});
            valuesToSave.add({SharedPreferencesService.customerCodeSelected :selectedCustomer?.accountCode});
            valuesToSave.add({SharedPreferencesService.storeIdSelected :selectedStore?.storeId});
            valuesToSave.add({SharedPreferencesService.storeSelected :selectedStore?.storeName});
            valuesToSave.add({SharedPreferencesService.soldSelected :isCheckedSold});
            valuesToSave.add({SharedPreferencesService.rfidSelected :isCheckedRFID});
            valuesToSave.add({SharedPreferencesService.rfSelected :isCheckedRF});
            valuesToSave.add({SharedPreferencesService.pushSelected :isCheckedPush});
            valuesToSave.add({SharedPreferencesService.customerSelectedJson :selectedCustomer?.toJson()});
            valuesToSave.add({SharedPreferencesService.storeSelectedJson :selectedStore?.toJson()});
            valuesToSave.add({SharedPreferencesService.groupSelected : selectedGroup!["groupName"]});
            valuesToSave.add({SharedPreferencesService.groupIdSelected : selectedGroup!["groupId"]});

            await SharedPreferencesService.saveMultipleSharedPreference(valuesToSave);
            
            if(docId == ''){
              await FirebaseService.insertTokenMobile(selectedCustomer!.accountCode,selectedStore!.storeId, tokenMobile!, isCheckedPush, isCheckedSold);
            }
            else{
              await FirebaseService.updateInfoTokenMobile(selectedCustomer!.accountCode, selectedStore!.storeId, docId.toString(), isCheckedPush, isCheckedSold);
            }

            await db.deleteEvents();
            await db.deleteEnrich();

            setState(() {
              isSavingConfig = false;
            });

            Fluttertoast.showToast(msg: messageSaved);

            appRouter.go("/events");
          }
        }
      } 
    }
  }


  @override
  Widget build(BuildContext context) {
    final scaffoldKey= GlobalKey<ScaffoldState>();
    final isTesting = const bool.fromEnvironment('INTEGRATION_TEST', defaultValue: false);
    final token = tokenMobile ?? (isTesting ? 'test_token_123' : null);

    if (token == null) {
      return const Scaffold(
        body: Center(child: Text('Token no disponible')),
      );
    }

    return isLoadingInfo ? 
      Scaffold(body: CustomLoaderScreen(message: AppLocalizations.of(context)!.loading_customers_info)) : Scaffold(
      key: Key('settings_screen'),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomAppbar(),
      floatingActionButton: isSavingConfig || isLoadingInfo ? Text('') : 
      CustomFabButton(onPressed: saveConfig, icon: Icons.check),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      appBar: CustomAppbar(includeBottomBar: false, tokenMob: tokenMobile!),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      body: isSavingConfig ? CustomLoaderScreen(message: AppLocalizations.of(context)!.saving_configuration): isLoadingInfo ? CustomLoaderScreen(message: 'Loading Customers Info',): SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 50),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children:[
                        TitleText(textShow: AppLocalizations.of(context)!.user, icon: Icons.person_pin_outlined),
                        userAuth == null ? CircularProgressIndicator()
                        : Text(userAuth!, style: 
                          TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15
                          ),              
                        ),
                        SizedBox(height: 15),
          
                        TitleText(textShow: AppLocalizations.of(context)!.customer, icon: Icons.contact_page_outlined),
          
                        isLoadingCustomers ? Center(child: CircularProgressIndicator()) : 
                        DropdownSearch<CustomerResponseEntity>(
                          items: (String filter, LoadProps? loadProps) {
                            if (filter.isEmpty) return customerList;
                            return customerList
                                .where((c) => '${c.accountCode} - ${c.description}'
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                )
                                .toList();
                          },
                          itemAsString: (CustomerResponseEntity c) => '${c.accountCode} - ${c.description}',
                          selectedItem: selectedCustomer,
                          compareFn: (a, b) => a.customerToken == b.customerToken,
                          onChanged: (customer) {
                            if (customer != null) {
                              setState(() {
                                selectedCustomer = customer;
                              });
                              loadStores(customer.customerToken);
                            }
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.search,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
          
                        TitleText(textShow: AppLocalizations.of(context)!.site, icon: Icons.store_outlined),
          
                        isLoadingStores ? Center(child: CircularProgressIndicator()) : 
                          DropdownSearch<StoresResponseEntity>(
                            items: (String filter, LoadProps? loadProps) {
                              if (filter.isEmpty) return storeList;
                              
                              return storeList
                                .where((s) => '${s.storeId} - ${s.storeName}'
                                .toLowerCase()
                                .contains(filter.toLowerCase()))
                                .toList();
                            },
                            itemAsString: (StoresResponseEntity s) => '${s.storeId} -  ${s.storeName}',
                            selectedItem: selectedStore,
                            compareFn: (a, b) => a.storeId == b.storeId,
                            onChanged: (store) {
                              if (store != null) {
                                setState(() {
                                  selectedStore = store;
                                });
                                loadGroups(store.groups);
                              }
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.search_site,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
          
                          SizedBox(height: 20),

                          TitleText(textShow: AppLocalizations.of(context)!.group, icon: Icons.door_sliding_outlined),
                          
                          SizedBox(
                            width: double.infinity,
                            child: 
                            isLoadingGroups ? Center(child: CircularProgressIndicator()) : 
                            DropdownSearch<Map<String, dynamic>>(
                              items: (String filter, LoadProps? loadProps) {
                                if (filter.isEmpty) return groupList;

                                return groupList
                                    .where((g) => g["groupName"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                    .toList();
                              },
                              itemAsString: (Map<String, dynamic> g) => g["groupName"].toString(),
                              selectedItem: selectedGroup,   
                              compareFn: (a, b) => a["groupId"] == b["groupId"],    
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedGroup = value;
                                  });
                                }
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.search_group,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )


                            //   DropdownButton<String>(
                              
                            //   elevation: 16,
                            //   style: TextStyle(color: AppTheme.primaryColor),
                              
                            //   underline: Container(height: 1, color: AppTheme.primaryColor),
                            //   onChanged: (String? value) {
                            //     setState(() {
                            //     //dropdownValue = value!;
                            //     });
                            //   },
                            //   items: listGroups.map<DropdownMenuItem<String>>((String value) {
                            //     return DropdownMenuItem<String>(value: value, child: Text(value));
                            //   }).toList()
                            // ),

                          ),

                          
                          SizedBox(height: 20),

                          TitleText(textShow: AppLocalizations.of(context)!.technologies, icon: Icons.wifi_tethering),
                          SizedBox(height: 10),
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            crossAxisCount: 2, 
                            childAspectRatio: 4,
                            children: [
                              
          
                              TechCheckbox(label: 'RFID',
                                value: isCheckedRFID,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedRFID = value!;
                                  });
                                },
                              ),
          
                              TechCheckbox(label: 'RF',
                                value: isCheckedRF,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedRF = value!;
                                  });
                                },
                              ),

                              TechCheckbox(label: AppLocalizations.of(context)!.sold,
                                value: isCheckedSold,onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedSold = value!;
                                  });
                                },
                              ),
                              
                            ],
                          ),
          
                          SizedBox(height: 20),
          
                          TitleText(textShow: AppLocalizations.of(context)!.notifications, icon: Icons.notifications_active_outlined),
          
                          TechCheckbox(label: AppLocalizations.of(context)!.push_notifications,
                            value: isCheckedPush,onChanged: (bool? value) {
                              setState(() {
                                isCheckedPush = value!;
                              });
                            },
                          ),
                      ]
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  
}


