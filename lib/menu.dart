import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() => runApp(MenuClass());

Drawer menuDrawer(BuildContext context) {
  return Drawer(
      child:
      ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Colors.blue,
                  Colors.lightBlueAccent
                ])
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          'assets/images/gobel.png', width: 70, height: 70,)
                    ),
                    elevation: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                        child: Text("Noval Debby Prasetyono",
                          style: TextStyle(color: Colors.white, fontSize: 17),)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Center(
                        child: Text("(System Admin)",
                          style: TextStyle(color: Colors.white, fontSize: 12),)
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Remaining Task'),
            leading: Icon(Icons.assignment_late),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('Setting'),
            leading: Icon(Icons.settings),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('About Us'),
            leading: Icon(Icons.info_outline),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.power_settings_new),
            onTap: () => Navigator.pop(context),
          )
        ],
      )
  );
}

class MenuClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unified Process',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        drawer: menuDrawer(context),
        appBar: AppBar(
          title: Text('Unified Process'),
        ),
        body: MenuList()
      ),
    );
  }
}

class MenuList extends StatelessWidget{

  Material menuItems(String icon, String title){
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.circular(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset(icon, width: 75, height: 75, fit: BoxFit.fill),
            ),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(10),
      children: <Widget>[
        menuItems('assets/images/search.png', "Search Product"),
        menuItems('assets/images/production.png', "Output"),
        menuItems('assets/images/transfer.png', "Transfer"),
        menuItems('assets/images/receipt.png', "Receipt"),
        menuItems('assets/images/allocation.png', "Allocation"),
        menuItems('assets/images/count.png', "Tag Count"),
        menuItems('assets/images/delivery.png', "Delivery"),
      ],
      staggeredTiles: [
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
        StaggeredTile.extent(1, 125),
      ],
    );
  }
}