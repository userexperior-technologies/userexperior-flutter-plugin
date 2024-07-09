import 'dart:math';

import 'package:injectable/injectable.dart';

import 'models/v_list_item.dart';

@injectable
class VListDataService {
  final List<VListItem> _vList = List.generate(
      25,
      (index) => VListItem(
          image: _getRandomImage(),
          firstLabel: 'item number ${index + 1}',
          secondLabel: 'Some Extra Data'));

  static String _getRandomImage() {
    return 'lib/assets/images/${(Random().nextInt(24) + 1).toString()}.jpeg';
  }

  List<VListItem> get vList => _vList;
}
