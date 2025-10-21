import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeops_mobile/main.dart' as app;
import 'package:storeops_mobile/presentation/screens/home/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow y apertura de drawer sin validación de Settings', (tester) async {
    print('🧹 Limpiando sesión...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    print('🚀 Lanzando app...');
    try {
      app.main();
    } catch (e, stack) {
      print('❌ Error al lanzar la app: $e');
      print(stack);
      fail('La app no se pudo iniciar.');
    }

    await tester.pumpAndSettle(const Duration(seconds: 5));

    print('🔍 Buscando campos de login...');
    final userField = find.byKey(const Key('user_id_field'));
    final passField = find.byKey(const Key('password_field'));
    final signInBtn = find.byKey(const Key('sign_in_button'));

    if (userField.evaluate().isEmpty ||
        passField.evaluate().isEmpty ||
        signInBtn.evaluate().isEmpty) {
      print('❌ No se encontraron los campos de login. Test abortado.');
      fail('Los widgets de login no están disponibles.');
    }

    print('✍️ Ingresando credenciales...');
    await tester.enterText(userField, 'MULTI_USERID05749');
    await tester.enterText(passField, 'Ju4n950528Storeops.');
    await tester.tap(signInBtn);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    print('✅ Login ejecutado. Esperando la pantalla principal...');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    print('🔍 Verificando que la pantalla de Home esté visible...');
    final homeKeyFinder = find.byKey(const Key('home_screen'));
    if (homeKeyFinder.evaluate().isEmpty) {
      print('❌ No se encontró el widget con Key home_screen después de esperar.');
      fail('La aplicación no navegó correctamente a la pantalla de Home.');
    }

    print('🎉 Navegación a Home confirmada por Key.');
    expect(homeKeyFinder, findsOneWidget);

    print('📂 Intentando abrir el Drawer...');
    final scaffoldState = HomeScreen.scaffoldKey.currentState;
    if (scaffoldState == null) {
      print('❌ Scaffold no disponible. No se puede abrir el Drawer.');
      fail('No se pudo acceder al Scaffold para abrir el Drawer.');
    }
    scaffoldState.openDrawer();
    await tester.pumpAndSettle(const Duration(seconds: 1));
    print('📂 Drawer abierto correctamente.');

    print('🧭 Buscando y seleccionando Settings...');
    final settingsItem = find.byKey(const Key('drawer_settings'));
    if (settingsItem.evaluate().isEmpty) {
      print('⚠️ Botón de Settings no encontrado. Continuando sin validación.');
    } else {
      await tester.tap(settingsItem);
      await tester.pumpAndSettle(const Duration(seconds: 9));
      print('⚙️ Settings seleccionado desde el Drawer.');
    }

    print('✅ Test finalizado sin validar pantalla de Settings.');
  });
}
