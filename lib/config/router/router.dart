import 'package:go_router/go_router.dart';
import 'package:storeops_mobile/main.dart';
import 'package:storeops_mobile/presentation/screens.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';


final appRouter = GoRouter(
  initialLocation: '/login',
  navigatorKey: navKey,
  redirect: (context, state) async {
    final token = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenKey);
    final client = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.customerSelected);

    if (token == null && state.matchedLocation != '/login') {
      return '/login';
    }
    if (token != null && state.matchedLocation == '/login') {
      if(client==null){
        return '/settings';
      }
      else{
        return '/events';
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context,state) => LoginScreen()
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context,state) => HomeScreen()
    ),
    GoRoute(
      path: '/events',
      name: EventsScreen.name,
      builder: (context,state) => EventsScreen()
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      builder: (context,state) => SettingsScreen()
    ),
    GoRoute(
      path: '/reports',
      name: ReportsScreen.name,
      builder: (context,state) => ReportsScreen()
    ),
     GoRoute(
      path: '/reportsSold',
      name: ReportsSoldScreen.name,
      builder: (context,state) => ReportsSoldScreen()
    )
  ]
);