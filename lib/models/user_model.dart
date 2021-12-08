import 'package:flutter/material.dart';

final String TABLE_USER = 'tbl_user';
final String COL_USER_ID='user_id';
final String COL_USER_NAME = 'user_name';
final String COL_USER_PHONE = 'user_phone';
final String COL_USER_EMAIL = 'user_email';
final String COL_USER_PASSWORD = 'user_password';

class UserModel {
  int ?id;
  String name = '';
  String email = '';
  String phone = '';
  String password = '';

  UserModel(
      {this.id,this.name = '', this.email = '', this.phone = '', this.password = ''});

  UserModel.fromMap(Map<String, dynamic> map) {
    id=map[COL_USER_ID];
    name = map[COL_USER_NAME];
    phone = map[COL_USER_PHONE];
    email = map[COL_USER_EMAIL];
    password = map[COL_USER_PASSWORD];
  }

  Map<String, dynamic> toMap() {
    var usrMap = <String, dynamic>{
      COL_USER_NAME: name,
      COL_USER_PHONE: phone,
      COL_USER_EMAIL: email,
      COL_USER_PASSWORD: password,
    };
    if(id!=null){
      usrMap[COL_USER_ID]=id;
    }
    return usrMap;
  }

  @override
  String toString() {
    return 'UserModel{ name: $name, email: $email, phone: $phone, password: $password}';
  }
}
