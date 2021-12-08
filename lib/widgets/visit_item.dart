import 'package:flutter/material.dart';
import 'package:new_login_app/helper/db_helper.dart';
import 'package:new_login_app/models/visit_model.dart';
import 'package:new_login_app/pages/add_place.dart';
import 'package:new_login_app/pages/google_map.dart';
import 'package:new_login_app/pages/visit_list.dart';

class VisitItem extends StatefulWidget {
  final VisitModel visitModel;

  VisitItem(this.visitModel);

  @override
  _VisitItemState createState() => _VisitItemState();
}

class _VisitItemState extends State<VisitItem> {
  void _deletePlace() async {
    await DBHelper.deletePlace(widget.visitModel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(widget.visitModel.name.toString()),
              flex: 5,
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(
                  Icons.navigation,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyGoogleMap(
                        name: widget.visitModel.name.toString(),
                        latitude: widget.visitModel.latitude,
                        longitude: widget.visitModel.longitude,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Edit'),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 1,
                  ),
                ],
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Places(
                          placeID: widget.visitModel.id,
                        ),
                      ),
                    );
                  } else if (value == 1) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete'),
                        content: Text('Are you sure to delete this item?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('CANCEL'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          ElevatedButton(
                            child: Text('DELETE'),
                            onPressed: () {
                              _deletePlace();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VisitList(),
                                  ),
                                  (Route<dynamic> route) => false);
                            },
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// title: Text(widget.visitModel.name.toString()),
// trailing: IconButton(
// icon: const Icon(
// Icons.navigation,
// color: Colors.blueGrey,
// ),
// onPressed: () {},
// ),
// IconButton(icon: Icon(Icons.menu),onPressed: (){},)
