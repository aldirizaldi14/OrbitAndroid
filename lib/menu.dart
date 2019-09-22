import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MenuClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: menuDrawer(context),
        appBar: AppBar(
          title: Text('Unified Process'),
        ),
        body: menuList(context)
    );
  }
}

Drawer menuDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
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
            Navigator.pushNamed(context, '/task');
          },
        ),
        ListTile(
          title: Text('Setting'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.pushNamed(context, '/setting');
          },
        ),
        ListTile(
          title: Text('About Us'),
          leading: Icon(Icons.info_outline),
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        ListTile(
          title: Text('Log Out'),
          leading: Icon(Icons.power_settings_new),
          onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
        )
      ],
    )
  );
}

Material menuItems(BuildContext context, String icon, String title, String route){
  return Material(
    color: Colors.white,
    elevation: 10,
    borderRadius: BorderRadius.circular(24),
    child: InkWell(
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
      onTap: () { Navigator.pushNamed(context, route); },
    )
  );
}

StaggeredGridView menuList(BuildContext context){
  return StaggeredGridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    padding: EdgeInsets.all(10),
    children: <Widget>[
      menuItems(context, 'assets/images/production.png', "Output", '/production_output'),
      menuItems(context, 'assets/images/transfer.png', "Transfer", '/production_transfer'),
      menuItems(context, 'assets/images/receipt.png', "Receipt", '/warehouse_receipt'),
      menuItems(context, 'assets/images/allocation.png', "Allocation", '/warehouse_allocation'),
      menuItems(context, 'assets/images/count.png', "Tag Count", '/warehouse_tag_count'),
      menuItems(context, 'assets/images/delivery.png', "Delivery", '/delivery'),
      menuItems(context, 'assets/images/search.png', "Search Product", '/product_search'),
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