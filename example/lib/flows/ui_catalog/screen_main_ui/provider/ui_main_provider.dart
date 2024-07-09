import 'package:flutter/material.dart';

import '../../drawer_pages/lib_pages.dart';
import '../models/drawer_item.dart';
import '../widgets/ui_main_page.dart';

class UiMainProvider with ChangeNotifier {
  int _selectedPageIndex = 0;

  final List<DrawerItem> _drawerItems = [
    DrawerItem(title: 'main', page: const UIMainPage()),
    DrawerItem(title: 'input field', page: const InputFieldPage()),
    DrawerItem(title: 'vertical list', page: const VerticalListPage()),
    DrawerItem(title: 'horizontal list', page: const HorizontalListPage()),
    DrawerItem(title: 'grid', page: const GridPage()),
    DrawerItem(title: 'video', page: const VideoPage()),
    DrawerItem(title: 'webview', page: WebViewPage()),
    DrawerItem(title: 'webview form', page: FormWebviewPage()),
    DrawerItem(title: 'animations', page: const AnimationsPage()),
  ];

  int get selectedPageIndex => _selectedPageIndex;

  List<DrawerItem> get drawerItems => _drawerItems;

  DrawerItem get selectedPage => _drawerItems[_selectedPageIndex];

  set setSelectedPage(int newIndex) {
    _selectedPageIndex = newIndex;
    notifyListeners();
  }
}
