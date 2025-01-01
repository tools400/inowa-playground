import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:inowa/src/ui/home/home_screen_drawer.dart';

import '/src/firebase/fb_service.dart';
import '/src/ui/device_detail/boulder_list_panel.dart.dart';
import '../settings/internal/color_theme.dart';

enum PageMode { boulderList, sort, addBoulder, settings }

class BoulderList extends StatefulWidget {
  const BoulderList({super.key});

  @override
  State<BoulderList> createState() => _BoulderListState();
}

class _BoulderListState extends State<BoulderList> {
  final ScrollController scrollController = ScrollController();

  bool isSelected = false;
  int _currentIndex = 0;
  PageMode pageMode = PageMode.boulderList;

  @override
  Widget build(BuildContext context) =>
      Consumer<FirebaseService>(builder: (_, firebase, __) {
        return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.mnu_Problems),
              backgroundColor: ColorTheme.inversePrimary(context),
            ),
            drawer: HomePageDrawer(),
            onDrawerChanged: (isOpen) {
              // call setState() for refreshing the page,
              // if drawer has been closed
              setState(() {});
            },
            bottomNavigationBar: bottomNavigationBar(),
            body: BoulderListPanel());
      });

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: isSelected ? Colors.orange : null,
      onTap: (int index) {
        setState(() {
          if (isSelected && index == _currentIndex) {
            isSelected = false;
            pageMode = PageMode.boulderList;
            return;
          }
          _currentIndex = index;

          switch (_currentIndex) {
            case 0:
              pageMode = PageMode.sort;
              isSelected = true;
            case 1:
              pageMode = PageMode.addBoulder;
              isSelected = true;
            case 2:
              pageMode = PageMode.settings;
              isSelected = true;
            default:
              throw UnsupportedError(
                'Unsupported navigation item.',
              );
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.sort),
          label: 'Sort',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.plus_one),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
