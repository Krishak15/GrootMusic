import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grootmusic/views/favourites_screen.dart';
import 'package:grootmusic/views/home_screen.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomBarController.stream.listen((opened) {
      debugPrint('Bottom bar ${opened ? 'opened' : 'closed'}');
    });
  }

  int pageIndex = 0;
  List<Widget> pageList = [HomeScreen(), FavScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: IndexedStack(
        index: pageIndex,
        children: pageList,
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 10, left: 50, right: 50),
          child: Stack(
            children: [
              DotNavigationBar(
                backgroundColor: Colors.white,
                curve: Curves.fastOutSlowIn,
                margin: EdgeInsets.only(left: 10, right: 10),
                currentIndex: pageIndex,
                enablePaddingAnimation: true,
                onTap: (value) {
                  setState(() {});
                  pageIndex = value;
                },
                // dotIndicatorColor: Colors.deepPurple,
                unselectedItemColor: Colors.grey[300],
                // enableFloatingNavBar: false,

                items: [
                  /// Home
                  DotNavigationBarItem(
                      icon: Icon(Iconsax.home5),
                      selectedColor: Colors.deepPurple),

                  /// Likes
                  DotNavigationBarItem(
                      icon: Icon(Iconsax.heart5), selectedColor: Colors.red),
                ],
              ),
            ],
          )),
      // BottomBarWithSheet(
      //   disableMainActionButton: true,
      //   autoClose: true,
      //   curve: Curves.easeInOutCubic,
      //   controller: _bottomBarController,
      //   bottomBarTheme: BottomBarTheme(
      //     selectedItemIconSize: 30,
      //     contentPadding: EdgeInsets.only(top: 15),
      //     heightClosed: 60,
      //     decoration: BoxDecoration(
      //       color: Colors.deepPurple.shade500,
      //       borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      //     ),
      //     itemIconColor: Colors.white60,
      //     itemIconSize: 30,
      //     selectedItemIconColor: Colors.white,
      //     itemTextStyle: const TextStyle(
      //       color: Colors.grey,
      //       fontSize: 10.0,
      //     ),
      //     selectedItemTextStyle: TextStyle(
      //       color: Colors.blue,
      //       fontSize: 10.0,
      //     ),
      //   ),
      //   onSelectItem: (index) => debugPrint('$index'),
      //   sheetChild: Center(
      //     child: Text(
      //       "Another content",
      //       style: TextStyle(
      //         color: Colors.grey[600],
      //         fontSize: 20,
      //         fontWeight: FontWeight.w900,
      //       ),
      //     ),
      //   ),
      //   items: const [
      //     BottomBarWithSheetItem(icon: Iconsax.home),
      //     BottomBarWithSheetItem(icon: Iconsax.heart),
      //   ],
      // ),
    );
  }
}
