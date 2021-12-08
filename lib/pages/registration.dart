import 'package:flutter/material.dart';
import 'package:new_login_app/helper/db_helper.dart';
import 'package:new_login_app/helper/toast_helper.dart';
import 'package:new_login_app/models/user_model.dart';
import 'login.dart';

class MyRegistration extends StatefulWidget {
  const MyRegistration({Key? key}) : super(key: key);

  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  validateEmail(String uEmail) {
    final emailReg = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailReg.hasMatch(uEmail);
  }

  final user = UserModel();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _saveUser() async {
    String uName = _nameController.text;
    String uEmail = _emailController.text;
    String uPhone = _phoneController.text;
    String uPassword = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      print('ami');
      _formKey.currentState!.save();
      print('save');

      UserModel uModel = UserModel(
          name: uName, password: uPassword, email: uEmail, phone: uPhone);
      print('why');

      await DBHelper.insertUser(uModel).then((userData) {
        print('success');
        MyAlertDialog(context, "Successfully Saved");
        print('success 2');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyLogin(),
          ),
        );
      },).catchError((error) {
        print(error);
        MyAlertDialog(context, "Data Saving Failed");
      },);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Create Account'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.name = value as String;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 11) {
                      return 'Please enter valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.phone = value as String;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        validateEmail(value) != true) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.email = value as String;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.password = value as String;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey,),
                  onPressed: () {
                    _saveUser();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
