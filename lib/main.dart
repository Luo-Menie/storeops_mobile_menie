import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/core/dio_client.dart';
import 'package:storeops_mobile/data/repositories/auth_repository_impl.dart';
import 'package:storeops_mobile/data/repositories/customers_repository_impl.dart';
import 'package:storeops_mobile/data/repositories/stores_repository_impl.dart';
import 'package:storeops_mobile/data/sources/auth_datasource.dart';
import 'package:storeops_mobile/data/sources/customers_datasource.dart';
import 'package:storeops_mobile/data/sources/stores_datasouce.dart';
import 'package:storeops_mobile/domain/repositories/auth_repository.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';
import 'package:storeops_mobile/firebase_options.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/presentation/screens/home/home_screen.dart';
import 'package:storeops_mobile/presentation/screens/login/login_screen.dart';
import 'package:storeops_mobile/services/notifications_service.dart';
import 'package:go_router/go_router.dart';
import 'package:storeops_mobile/presentation/screens/settings/settings_screen.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async { await Firebase.initializeApp(); }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const isTesting = bool.fromEnvironment('INTEGRATION_TEST', defaultValue: false);

  final dioClient = DioClient();
  final loginDS = AuthRemoteDataSource(dioClient);
  final customersDS = CustomersDatasource(dioClient: dioClient);
  final storeDS = StoresDatasource(dioClient: dioClient);

  final loginRepo = AuthRepositoryImpl(loginDS); 
  final customerRepo = CustomerRepositoryImpl(customersDS);
  final storesRepo = StoresRepositoryImpl(storeDS);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!isTesting) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService().init();
  }

  final GoRouter router = isTesting
      ? GoRouter(
          initialLocation: '/login',
          routes: [
            GoRoute(
              path: '/login',
              name: 'login_screen',
              builder: (context, state) => LoginScreen(),
            ),
            GoRoute(
              path: '/home',
              name: 'home_screen',
              builder: (context, state) => HomeScreen(key: Key('home_screen')),
            ),
            GoRoute(
              path: '/settings',
              name: 'settings_screen',
              builder: (context, state) => SettingsScreen(key: Key('settings_screen')),
            ),
          ],
        )
      : appRouter;

  runApp(
    MultiProvider(
      providers: [
        Provider<CustomerRepository>(create: (_) => customerRepo),
        Provider<AuthRepository>(create: (_) => loginRepo),
        Provider<StoresRepository>(create: (_) => storesRepo),
      ],
      child: MainApp(router: router),
    ),
  );
}

class MainApp extends StatelessWidget {
  final GoRouter router;

  const MainApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
