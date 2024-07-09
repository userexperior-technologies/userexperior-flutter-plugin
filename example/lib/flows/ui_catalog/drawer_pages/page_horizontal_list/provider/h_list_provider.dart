import 'package:flutter/foundation.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

import '../data/models/h_list_item.dart';
import '../repository/h_list_repository.dart';

class HListProvider with ChangeNotifier {
  late final List<HListItem> _hList;

  HListProvider() {
    _hList = dependencyProvider<HListRepository>().getHList();
  }

  List<HListItem> get hList => _hList;
}
