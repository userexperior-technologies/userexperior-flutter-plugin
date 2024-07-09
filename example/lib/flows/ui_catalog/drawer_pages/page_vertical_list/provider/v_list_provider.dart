import 'package:flutter/foundation.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

import '../data/models/v_list_item.dart';
import '../repository/v_list_repository.dart';

class VListProvider with ChangeNotifier {
  late final List<VListItem> _vList;

  VListProvider() {
    _vList = dependencyProvider<VListRepository>().getVList();
  }

  List<VListItem> get vList => _vList;
}
