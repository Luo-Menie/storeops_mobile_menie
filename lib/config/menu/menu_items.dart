import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class MenuItems {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItems({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

List<MenuItems> getAppMenuItems(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  return [
    MenuItems(
      title: localizations.real_time_events,
      subTitle: localizations.events_for_readers,
      link: '/events',
      icon: Icons.cloud_sync_outlined,
    ),
    MenuItems(
      title: localizations.daily_report,
      subTitle: localizations.report_today,
      link: '/reports',
      icon: Icons.content_paste_search_sharp,
    ),
    MenuItems(
    title: localizations.sold_report,
    subTitle: 'Report sold', 
    link: '/reportsSold', 
    icon: Icons.shopping_cart_checkout_sharp
  ),
    MenuItems(
      title: localizations.settings,
      subTitle: localizations.config_app,
      link: '/settings',
      icon: Icons.settings_outlined,
    ),
  ];
}