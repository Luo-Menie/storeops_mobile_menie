import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/main.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class DioClient {
  final Dio dio;
  String tokenMobile = '';

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://apickp.azurewebsites.net/storeops/api',
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status != null && status < 500;
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPreferencesService.getSharedPreference(
              SharedPreferencesService.tokenKey);

          final rawMobileToken = await SharedPreferencesService.getSharedPreference(
              SharedPreferencesService.tokenMobile);
          tokenMobile = rawMobileToken ?? '';

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            final context = navKey.currentState?.overlay?.context;

            if (context != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.session_expired),
                    content: Text(
                      AppLocalizations.of(context)!.session_expired_message,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await SharedPreferencesService.clearAllSharedPreference();
                          await SharedPreferencesService.saveSharedPreference(
                              SharedPreferencesService.tokenMobile, tokenMobile);
                          appRouter.go('/login');
                        },
                        child: Text(AppLocalizations.of(context)!.accept),
                      ),
                    ],
                  );
                },
              );
            }
          }
          return handler.next(response);
        },
      ),
    );
  }
}
