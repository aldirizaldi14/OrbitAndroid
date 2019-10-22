import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:unified_process/helper/database_helper.dart';
import 'api_services.dart';

class MenuClass extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuClass> {
  SharedPreferences _sharedPreferences;

  String user_name = '';
  int user_group_id = 0;
  String user_group_name = '';
  String last_update = '';
  String token = '';
  bool progress_sync = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPreferences();
  }

  void initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if(! _sharedPreferences.containsKey('USER_ID')){
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }else{
      setState(() {
        user_name = _sharedPreferences.getString('USER_FULLNAME');
        user_group_id = _sharedPreferences.getInt('USER_GROUP_ID');
        if(_sharedPreferences.getInt('USER_GROUP_ID') == 1){
          user_group_name = 'Admin';
        }else if(_sharedPreferences.getInt('USER_GROUP_ID') == 2){
          user_group_name = 'Production';
        }else if(_sharedPreferences.getInt('USER_GROUP_ID') == 3){
          user_group_name = 'Warehouse';
        }else if(_sharedPreferences.getInt('USER_GROUP_ID') == 9){
          user_group_name = 'Viewer';
        }else{
          user_group_name = '-';
        }
        last_update = _sharedPreferences.getString('LAST_UPDATE') ?? '-';
        token = _sharedPreferences.getString('USER_TOKEN') ?? '';
      });
      getData();
    }
  }

  void getData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    setState(() {
      progress_sync = true;
    });
    bool success = true;
    if(! await apiSyncWarehouse(token, last_update, dbHelper)){
      success = false;
    }
    // first request also used as check connection, if fail, stop the job
    if(success){
      if(! await apiSyncArea(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncLine(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncProduct(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncProduction(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncTransfer(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncTransferdet(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncReceipt(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncReceiptdet(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncAllocation(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncAllocationdet(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncDelivery(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncDeliverydet(token, last_update, dbHelper)){ success = false; }
      if(! await apiSyncQty(token, last_update, dbHelper)){ success = false; }
    }

    if(success){
      setState(() {
        progress_sync = false;
        last_update = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        _sharedPreferences.setString('LAST_UPDATE', last_update);
      });
    }else{
      Toast.show("Unable to process request", context);
      setState(() {
        progress_sync = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UNIFIED PROCESS'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Material(
                color: Colors.white,
                elevation: 10,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                    onTap: () {
                      getData();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Center(
                                child: progress_sync ? Text('Synchronizing data...') : Text('Last Update : ' + last_update)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Icon(Icons.sync),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
            Expanded(
              child: menuList(context),
            )
          ],
        ),
      drawer: Drawer(
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
                              'assets/images/logo.png', width: 70, height: 70,)
                        ),
                        elevation: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Center(
                            child: Text(user_name,
                              style: TextStyle(color: Colors.white, fontSize: 17),)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Center(
                            child: Text(user_group_name,
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
                title: Text('Change Password'),
                leading: Icon(Icons.lock),
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
                onTap: () {
                  _sharedPreferences.clear();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                }
              )
            ],
          )
      ),
    );
  }

  Widget menuItems(BuildContext context, String icon, String title, String route){
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
        onTap: () {
          if(route != ''){
            Navigator.pushNamed(context, route);
          }
        },
      )
    );
  }

  StaggeredGridView menuList(BuildContext context){
    if(user_group_id == 1){
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
          menuItems(context, 'assets/images/delivery.png', "Delivery", '/delivery'),
          menuItems(context, 'assets/images/search.png', "Search Product", '/product_search'),
          menuItems(context, 'assets/images/tag.png', "Tag Count", '/tagcount'),
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
    }else if(user_group_id == 2){
      return StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          menuItems(context, 'assets/images/production.png', "Output", '/production_output'),
          menuItems(context, 'assets/images/transfer.png', "Transfer", '/production_transfer'),
          menuItems(context, 'assets/images/search.png', "Search Product", '/product_search'),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
        ],
      );
    }else if(user_group_id == 3){
      return StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          menuItems(context, 'assets/images/receipt.png', "Receipt", '/warehouse_receipt'),
          menuItems(context, 'assets/images/allocation.png', "Allocation", '/warehouse_allocation'),
          menuItems(context, 'assets/images/delivery.png', "Delivery", '/delivery'),
          menuItems(context, 'assets/images/search.png', "Search Product", '/product_search'),
          menuItems(context, 'assets/images/tag.png', "Tag Count", '/tagcount'),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
          StaggeredTile.extent(1, 125),
        ],
      );
    }else{
      return StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          menuItems(context, 'assets/images/search.png', "Search Product", '/product_search'),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 125),
        ],
      );
    }
  }
}