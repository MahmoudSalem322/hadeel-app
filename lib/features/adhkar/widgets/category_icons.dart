import 'package:flutter/material.dart';

IconData adhkarCategoryIcon(String key) => switch (key) {
      'morning_evening' => Icons.wb_twilight_rounded,
      'after_prayer' => Icons.mosque_outlined,
      'sleep' => Icons.bedtime_outlined,
      'waking' => Icons.wb_sunny_outlined,
      'home_leave' => Icons.logout_rounded,
      'home_enter' => Icons.home_outlined,
      'mosque' => Icons.mosque_rounded,
      'adhan' => Icons.campaign_outlined,
      'wudu' => Icons.water_drop_outlined,
      'food' => Icons.restaurant_outlined,
      'travel' => Icons.flight_takeoff_rounded,
      'tasbih' => Icons.auto_awesome_outlined,
      _ => Icons.menu_book_outlined,
    };

IconData duaCategoryIcon(String key) => switch (key) {
      'quranic' => Icons.menu_book_rounded,
      'prophets' => Icons.auto_stories_outlined,
      'rizq' => Icons.account_balance_wallet_outlined,
      'tawbah' => Icons.replay_rounded,
      'travel' => Icons.flight_takeoff_rounded,
      'healing' => Icons.healing_outlined,
      'distress' => Icons.cloud_outlined,
      'morning_evening' => Icons.wb_twilight_rounded,
      'general' => Icons.volunteer_activism_outlined,
      _ => Icons.volunteer_activism_outlined,
    };
