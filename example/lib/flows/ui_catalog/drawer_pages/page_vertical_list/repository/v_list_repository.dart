import 'package:injectable/injectable.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

import '../data/models/v_list_item.dart';
import '../data/v_list_data_service.dart';

@injectable
class VListRepository {
  List<VListItem> getVList() {
    return dependencyProvider<VListDataService>().vList;
  }
}
