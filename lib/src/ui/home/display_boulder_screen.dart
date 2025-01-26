import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inowa/main.dart';
import 'package:inowa/src/firebase/model/db_boulder.dart';
import 'package:inowa/src/led/led_settings.dart';
import 'package:inowa/src/led/led_stripe_connector.dart';
import 'package:inowa/src/ui/home/tabs/boulder_moves_tab.dart';
import 'package:inowa/src/ui/home/tabs/boulder_properties_tab.dart';
import 'package:inowa/src/ui/logging/console_log.dart';
import 'package:inowa/src/ui/settings/internal/color_theme.dart';
import 'package:inowa/src/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '/src/firebase/fb_service.dart';

class DisplayBoulderScreen extends StatefulWidget {
  const DisplayBoulderScreen({super.key, required boulder})
      : _boulderItem = boulder;

  final FbBoulder _boulderItem;

  @override
  State<DisplayBoulderScreen> createState() => _DisplayBoulderScreenState();
}

class _DisplayBoulderScreenState extends State<DisplayBoulderScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabBarController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.addListener(() {
      if (_tabBarController.indexIsChanging) {
        setState(() {
          if (_tabBarController.previousIndex != 0 &&
              _tabBarController.index == 0) {
            ConsoleLog.log('Saving boulder');
          }
        });
        ConsoleLog.log("Selected Index: ${_tabBarController.index}");
      }
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer2<FirebaseService, LedSettings>(
          builder: (_, firebase, ledSettings, __) {
        var isHorizontalWireing = ledSettings.isHorizontalWireing;
        var ledConnector = LEDStripeConnector(peripheralConnector, ledSettings);

        // -----------------------------------
        // Send boulder to Bluetooth device
        // -----------------------------------
        ledConnector.sendBoulderToDevice(
            widget._boulderItem.moves(isHorizontalWireing).all);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget._boulderItem.name),
            backgroundColor: ColorTheme.inversePrimary(context),
          ),
          body: Padding(
            padding: appBorder,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                LayoutBuilder(builder: (context, boxConstraints) {
                  return PageView(
                    controller: _pageViewController,
                    onPageChanged: _handlePageViewChanged,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: boxConstraints.maxHeight -
                              PageIndicator.maxHeight,
                          child: BoulderPropertiesTab(
                            boulder: widget._boulderItem,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: boxConstraints.maxHeight -
                              PageIndicator.maxHeight,
                          child: BoulderMovesTab(
                            boulder: widget._boulderItem,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                PageIndicator(
                  numberOfPages: 2,
                  tabController: _tabBarController,
                  currentPageIndex: _currentPageIndex,
                  onUpdateCurrentPageIndex: _updateCurrentPageIndex,
                  isOnDesktopAndWeb: _isOnDesktopAndWeb,
                ),
              ],
            ),
          ),
        );
      });

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabBarController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabBarController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
        return true;
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }
}

/// Page indicator for desktop and web platforms.
///
/// On Desktop and Web, drag gesture for horizontal scrolling in a PageView is disabled by default.
/// You can defined a custom scroll behavior to activate drag gestures,
/// see https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag.
///
/// In this sample, we use a TabPageSelector to navigate between pages,
/// in order to build natural behavior similar to other desktop applications.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.numberOfPages,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int numberOfPages;
  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  static double maxHeight = 40;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
//        constraints: BoxConstraints(maxHeight: maxHeight),
        height: maxHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashRadius: 16.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (currentPageIndex <= 0) {
                  return;
                }
                onUpdateCurrentPageIndex(currentPageIndex - 1);
              },
              icon: const Icon(
                Icons.arrow_left_rounded,
                size: 32.0,
              ),
            ),
            TabPageSelector(
              controller: tabController,
              color: colorScheme.surface,
              selectedColor: colorScheme.primary,
            ),
            IconButton(
              splashRadius: 16.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (currentPageIndex >= numberOfPages - 1) {
                  return;
                }
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              },
              icon: const Icon(
                Icons.arrow_right_rounded,
                size: 32.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
