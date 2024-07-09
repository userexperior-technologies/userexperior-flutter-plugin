import 'dart:math';

import 'package:injectable/injectable.dart';

import 'models/h_list_item.dart';

@injectable
class HListDataService {
  final List<HListItem> _hList = List.generate(
      25,
      (index) => HListItem(
          firstImage: _getRandomImage(),
          secondImage: _getRandomImage(),
          label: 'item number ${index + 1}'));

  static String _getRandomImage() {
    return 'lib/assets/images/${(Random().nextInt(24) + 1).toString()}.jpeg';
  }

  List<HListItem> get hList => _hList;
}
