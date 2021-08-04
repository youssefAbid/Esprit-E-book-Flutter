import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/screens/current_read_screen.dart';
import 'package:esprit_ebook_app/screens/favorie_screen.dart';
import 'package:esprit_ebook_app/screens/finish_read_screen.dart';
import 'package:esprit_ebook_app/screens/home_screen.dart';
import 'package:esprit_ebook_app/screens/orders_screen.dart';
import 'package:esprit_ebook_app/screens/readers_screen.dart';
import 'package:esprit_ebook_app/screens/search_screen.dart';
import 'package:esprit_ebook_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  dynamic currentTab;
  Widget currentPage = HomeScreen();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Pages({
    Key key,
    this.currentTab,
  }) {
    if (currentTab == null) {
      currentTab = 2;
    }
  }

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int currentIndex;

  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(Pages oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              CurrentReadScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage =
              HomeScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage =
              OrdersScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage =
              SearchScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage =
              FavorieScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 5:
          widget.currentPage =
              ReaderScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 6:
          widget.currentPage =
              FinishReadScreen(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: DrawerWidget(),
      // endDrawer: FilterWidget(onFilter: (filter) {
      //   Navigator.of(context).pushReplacementNamed('/Pages', arguments: widget.currentTab);
      // }),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kIconColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: kProgressIndicator,
        currentIndex: widget.currentTab > 2 ? 1 : widget.currentTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            title: new Container(height: 0.0),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.location_on),
          //   title: new Container(height: 0.0),
          // ),
          BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kProgressIndicator,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: kProgressIndicator.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: kProgressIndicator.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(Icons.home, color: Colors.white),
              )),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            title: new Container(height: 0.0),
          ),
          // BottomNavigationBarItem(
          //   icon: new Icon(Icons.favorite),
          //   title: new Container(height: 0.0),
          // ),
        ],
      ),
    );
  }
}
