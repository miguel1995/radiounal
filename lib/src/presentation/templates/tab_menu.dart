import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:radiounal/src/presentation/templates/favourites_page.dart';
import 'package:radiounal/src/presentation/templates/followed_page.dart';

class TabMenuPage extends StatefulWidget {
  int tabIndex;

  TabMenuPage({Key? key, required this.tabIndex}) : super(key: key);

  @override
  State<TabMenuPage> createState() => _TabMenuPageState();
}

class _TabMenuPageState extends State<TabMenuPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  bool isDarkMode = false;
  final GlobalKey _topKey = GlobalKey(); // Usa una GlobalKey sin tipo específico
  var topPadding = 0.0;

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  void initState() {

    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    _tabController = TabController(length: 2, vsync: this);
    tabIndex = widget.tabIndex;
    _tabController.animateTo(tabIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeMethod().then((value) {
      setState(() {
        isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });

    final appBarRenderBox = _topKey.currentContext?.findRenderObject() as RenderBox?;
    if (appBarRenderBox != null) {
      topPadding = appBarRenderBox.size.height;
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: const Menu(),
        appBar: AppBarRadio(
          key: _topKey,
            enableBack: true
        ),
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                    : "assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: topPadding,
                  bottom: 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.transparent,
                    labelColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    labelStyle: TextStyle(
                      shadows: [
                        Shadow(
                            color: Theme.of(context).primaryColor,
                            offset: const Offset(0, -5))
                      ],
                      color: Colors.transparent,
                      decorationThickness: 2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decorationColor: const Color(0xFFFCDC4D),
                      decoration: TextDecoration.underline,
                    ),
                    unselectedLabelStyle: TextStyle(shadows: [
                      Shadow(
                          color: Theme.of(context).primaryColor,
                          offset: const Offset(0, -5))
                    ], color: Colors.transparent, fontSize: 13),
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(child: Text("Favoritos")),
                      Tab(child: Text("Siguiendo"))
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        FavouritesPage(),
                        FollowedPage(),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          tabs: [
            Text(
              "Favoritos",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text("Siguiendo",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16))
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
