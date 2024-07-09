import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

import 'data/models/h_list_item.dart';
import 'provider/h_list_provider.dart';

class HorizontalListPage extends StatelessWidget {
  const HorizontalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HListProvider(),
      child: Consumer<HListProvider>(
        builder: (context, hListProvider, child) {
          final List<HListItem> items = hListProvider.hList;
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _hListItem(context, index, items[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _hListItem(BuildContext context, int index, HListItem item) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _maskWhenNeeded(_itemImage(item.firstImage), index, 2),
            _maskWhenNeeded(_itemImage(item.secondImage), index, 3),
            _maskWhenNeeded(
                Container(
                    color: Colors.amber,
                    child: Text(
                      item.label,
                      style: gridLabelStyle,
                      textAlign: TextAlign.center,
                    )),
                index, 5),
          ],
        ),
      ),
    );
  }

  Widget _itemImage(String image) {
    return Expanded(
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _maskWhenNeeded(Widget child, int current, int threshold) {
    return child;// current % threshold == 0 ? UEMarker(child: child) : child;
  }
}
