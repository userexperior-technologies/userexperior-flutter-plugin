import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';

import '../provider/ui_main_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<UiMainProvider>(context);
    final list = mainProvider.drawerItems;
    return Drawer(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return UEMarker(
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.cyan[200],
                    ),
                    child: const Text('UI Screens')),
              );
            }

            return _maskWhenNeeded(
                index,
                ListTile(
                  title: Text(list[index - 1].title),
                  selected: mainProvider.selectedPageIndex == index - 1,
                  selectedColor: Colors.cyan,
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<UiMainProvider>(context, listen: false)
                        .setSelectedPage = index - 1;
                  },
                ));
          }),
    );
  }

  Widget _maskWhenNeeded(int index, Widget child) {
    return index % 3 == 0 ? UEMarker(child: child) : child;
  }
}
