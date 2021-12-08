import 'package:flutter/material.dart';
import 'package:new_login_app/helper/db_helper.dart';
import 'package:new_login_app/models/visit_model.dart';
import 'package:new_login_app/pages/visit_list.dart';

class Places extends StatefulWidget {
  int? placeID;

  Places({Key? key, this.placeID}) : super(key: key);

  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  List<VisitModel> visitList = [];
  final visit = VisitModel();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController,
      _latitudeController,
      _longitudeController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    if (widget.placeID != null) {
      DBHelper.getPlacesByID(widget.placeID!).then((model) {
        print(widget.placeID);
        _nameController?.text = model!.name.toString();
        _latitudeController?.text = model!.latitude.toString();
        _longitudeController?.text = model!.longitude.toString();
      });
    }
    super.initState();
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Future<int> id = DBHelper.insertPlace(TABLE_PLACE, visit.toMap());
      id.then((id) {
        if (id > 0) {
          print('Saved');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => VisitList()),
              (Route<dynamic> route) => false);
        } else {
          print('Not Saved');
        }
      });
      print(visit);
    }
  }

  void _updatePlace() {
    if (_formKey.currentState!.validate()) {
      (_formKey.currentState!.save());
      visit.id = widget.placeID;
      DBHelper.updatePlace(visit).then((value) {
        if (value > 0) {
          print('Update');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => VisitList()),
              (Route<dynamic> route) => false);
        } else {
          print('Could not updated');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.placeID == null ? 'Add New Place' : 'Update Place'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Place Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Please Save a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  visit.name = value as String;
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _latitudeController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Latitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Please Save a valid latitude';
                  }
                  return null;
                },
                onSaved: (value) {
                  visit.latitude = double.parse('$value');
                  print(visit.latitude);
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _longitudeController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Longitude',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Please Save a valid longitude';
                  }
                  return null;
                },
                onSaved: (value) {
                  visit.longitude = double.parse('$value');
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                onPressed: () {
                  if (widget.placeID == null) {
                    _savePlace();
                  } else {
                    _updatePlace();
                  }
                },
                child: Text(widget.placeID == null ? 'Save' : 'Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
