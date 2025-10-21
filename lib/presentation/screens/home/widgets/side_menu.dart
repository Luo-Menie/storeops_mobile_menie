import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storeops_mobile/config/menu/menu_items.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class SideMenu extends StatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onReturnFromSettings;

  const SideMenu({super.key, required this.scaffoldKey, this.onReturnFromSettings});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int navDrawerIndex=0;
  String? userAuth;
  String? selectedClient;
  String? selectedStore;
  String? storeId;
  bool isCheckingData = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isCheckingData=true;
    });
    _getUserAuth();
  }

  Future<void> _getUserAuth() async {
    final user= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.userAuthenticated);
    final client= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelected);
    final store= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeSelected);
    final storeNumber= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.storeIdSelected);

    setState(() {
      userAuth= user;
      selectedClient= client;
      selectedStore= store;
      storeId= storeNumber;
      isCheckingData= false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    // validate if notch exists
    final hasNotch= MediaQuery.of(context).viewPadding.top > 26;
    
    return Drawer(
    
    child:Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, hasNotch ? 50 : 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/storeops_logo2.png', height: 35, fit: BoxFit.contain),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor,
                    child: Image.asset('assets/images/checkpoint_logo_bco.png', height: 25, fit: BoxFit.contain),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isCheckingData ? CircularProgressIndicator():
                      userAuth==null ? CircularProgressIndicator() 
                      : Text(userAuth!, style: 
                        TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                        )
                      ),
                    
                      

                      isCheckingData ? CircularProgressIndicator():
                      selectedClient == null ? Text(AppLocalizations.of(context)!.waiting_client, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red)):
                      Text(selectedClient!, 
                      style: 
                        TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis
                        )
                      ),

                    
                      isCheckingData ? CircularProgressIndicator():
                      selectedStore == null ? Text(AppLocalizations.of(context)!.waiting_store, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red,)):
                      Text('$storeId- $selectedStore', style: 
                        TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis
                        )
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 10),
              
            ],
          ),
        ),

        Expanded(
          
          child: MediaQuery.removePadding(context: context,
            removeTop: true,
            child: NavigationDrawer(
              
              selectedIndex: null,
              onDestinationSelected: (value) {
                setState(() { 
                  navDrawerIndex = value;
                }
                );
            
                final menuItem = getAppMenuItems(context)[value];
            
                context.go(menuItem.link);
            
                widget.scaffoldKey.currentState?.closeDrawer();
                
              },
                children: getAppMenuItems(context).map((item) {
                  return NavigationDrawerDestination(
                  key: item.title == "Settings" ? const Key('drawer_settings') : null,
                  enabled: selectedClient == null ? item.title == "Settings" ? true : false : true,
                  icon: Icon(item.icon, size: 28),
                  label: Text(item.title, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                );
              }).toList(),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            children:[
            Image.asset('assets/images/checkpoint_logo.png', height: 25, fit: BoxFit.contain),
            SizedBox(height: 10),
            Text('v 1.0.7', 
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.start
            )
          ]
          ) 
        ),
      ],
    ),
    
    );


  }
}
