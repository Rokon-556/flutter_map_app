final String TABLE_PLACE='tbl_place';
final String COL_PLACE_ID='place_id';
final String COL_PLACE_NAME='place_name';
final String COL_PLACE_LATITUDE='place_latitude';
final String COL_PLACE_LONGITUDE='place_longitude';


class VisitModel {
   int? id;
   String? name;
   double? latitude;
   double? longitude;

  VisitModel(
      {this.id,
       this.name,
       this.latitude,
       this.longitude});

  VisitModel.fromMap(Map<String,dynamic>map){
    id=map[COL_PLACE_ID];
    name=map[COL_PLACE_NAME];
    latitude=map[COL_PLACE_LATITUDE];
    longitude=map[COL_PLACE_LONGITUDE];
  }

  Map<String,dynamic> toMap(){
    var plcMap=<String,dynamic>{
      COL_PLACE_ID:id,
      COL_PLACE_NAME:name,
      COL_PLACE_LATITUDE:latitude,
      COL_PLACE_LONGITUDE:longitude
    };
    if(id!=null){
      plcMap[COL_PLACE_ID]=id;
    }
    return plcMap;
  }

  @override
  String toString() {
    return 'VisitModel{id: $id , name: $name, latitude: $latitude, longitude: $longitude}';
  }
}
