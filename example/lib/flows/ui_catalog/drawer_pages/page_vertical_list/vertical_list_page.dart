import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

import 'data/models/v_list_item.dart';
import 'provider/v_list_provider.dart';

class VerticalListPage extends StatelessWidget {
  const VerticalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VListProvider(),
      child: Consumer<VListProvider>(
        builder: (context, vListProvider, child) {
          final List<VListItem> items = vListProvider.vList;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return _vListItem(items[index], context);
            },
          );
        },
      ),
    );
  }

  Widget _vListItem(VListItem item, BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _itemImage(item.image),
          Container(
              color: Colors.amber,
              child: Text(
                item.firstLabel,
                style: labelHeaderStyle,
                textAlign: TextAlign.center,
              )),
          Container(
              color: Colors.red,
              child: Text(
                item.secondLabel,
                style: labelStyle,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget _itemImage(String image) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
    );
  }
}
