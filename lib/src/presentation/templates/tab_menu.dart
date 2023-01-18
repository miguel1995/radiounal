import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/presentation/templates/favourites_page.dart';
import 'package:radiounal/src/presentation/templates/followed_page.dart';


class TabMenuPage extends StatefulWidget {
  const TabMenuPage({Key? key}) : super(key: key);

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage> with TickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body:   Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).appBarTheme.foregroundColor,

              tabs: [
                Tab(
                  child: Text("Favoritos",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
                Tab(
                  child: Text("Siguiendo",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      )
                  ),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FavouritesPage(),
                  FollowedPage(),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavigationBarRadio(),
    );
  }
}


class TabMenu extends StatefulWidget {
  const TabMenu({Key? key}) : super(key: key);

  @override
  State<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          tabs: [
            Text("Favoritos",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
            ),
            Text("Siguiendo",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              )
            )
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
        ],
      ),
    );
  }
}

