import 'package:injectable/injectable.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

import '../data/h_list_data_service.dart';
import '../data/models/h_list_item.dart';

@injectable
class HListRepository {
  List<HListItem> getHList() {
    return dependencyProvider<HListDataService>().hList;
  }
}
