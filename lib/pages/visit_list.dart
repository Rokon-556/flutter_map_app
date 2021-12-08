import 'package:flutter/material.dart';
import 'package:new_login_app/helper/db_helper.dart';
import 'package:new_login_app/models/visit_model.dart';
import 'package:new_login_app/pages/add_place.dart';
import 'package:new_login_app/pages/login.dart';
import 'package:new_login_app/widgets/visit_item.dart';

class VisitList extends StatefulWidget {
  const VisitList({Key? key}) : super(key: key);

  @override
  _VisitListState createState() => _VisitListState();
}

class _VisitListState extends State<VisitList> {
  List<VisitModel> visitList = [];

  getVisitList() {
    DBHelper.getPlace().then(
      (vList) {
        setState(
          () {
            visitList = vList;
            print("visitList");
            print(visitList);
          },
        );
      },
    );
  }

  @override
  void initState() {
    getVisitList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Places(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Appointed Places'),
        actions: <Widget>[
          const CircleAvatar(
            backgroundImage: AssetImage('images/spectrum.png'),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('SignOut'),
                value: 1,
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('SignOut'),
                    content: Text('Are you sure to Sign Out?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('CANCEL'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      ElevatedButton(
                        child: Text('SignOut'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyLogin(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return VisitItem(visitList[index]);
        },
        itemCount: visitList.length,
      ),
    );
  }
}
