
import 'package:byminuser/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'cart.dart';
import 'category_list.dart';
import 'home.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    Cart(has_bottomnav: true),
    Profile()
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //specify the location of the FAB
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom ==
            0.0, // if the kyeboard is open then hide, else show
        child: FloatingActionButton(
          backgroundColor: MyTheme.accent_color,
          onPressed: () {},
          tooltip: "start FAB",
          child: Container(
              margin: EdgeInsets.all(0.0),
              child: IconButton(
                  icon: new Image.asset('assets/square_logo.png'),
                  tooltip: 'Action',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Filter(
                        selected_filter: "sellers",
                      );
                    }));
                  })),
          elevation: 0.0,
        ),
      ),*/
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: BottomNavigationBar(
            selectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            // fixedColor: Theme.of(context).primaryColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/home.png",
                  color: _currentIndex == 0
                      ? Colors.blue
                      : Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
                label: "Home",
                // title: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Home",
                //     style: TextStyle(fontSize: 12),
                //   ),
                // )
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/categories.png",
                  color: _currentIndex == 1
                      // ? Theme.of(context).primaryColor
                      ? Colors.blue
                      : Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
                label: "Categories",
                // title: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Categories",
                //     style: TextStyle(fontSize: 12),
                //   ),
                // )
              ),
              /*BottomNavigationBarItem(
                icon: Icon(
                  Icons.circle,
                  color: Colors.transparent,
                ),
                title: Text(""),
              ),*/
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/cart.png",
                  color: _currentIndex == 2
                      // ? Theme.of(context).primaryColor
                      ?  Colors.blue
                      : Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
                label: "Cart",
                // title: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Cart",
                //     style: TextStyle(fontSize: 12),
                //   ),
                // )
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/profile.png",
                  color: _currentIndex == 3
                      // ? Theme.of(context).primaryColor
                      ?  Colors.blue
                      : Color.fromRGBO(153, 153, 153, 1),
                  height: 20,
                ),
                label: "Profile",
                // title: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Profile",
                //     style: TextStyle(fontSize: 12),
                //   ),
                // )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
