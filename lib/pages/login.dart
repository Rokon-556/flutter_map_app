import 'package:flutter/material.dart';
import 'package:new_login_app/helper/db_helper.dart';
import 'package:new_login_app/helper/toast_helper.dart';
import 'package:new_login_app/models/user_model.dart';
import 'package:new_login_app/pages/visit_list.dart';
import 'registration.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final user = UserModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    String uEmail = _emailController.text;
    String uPassword = _passwordController.text;
    if (uEmail.isEmpty) {
      MyAlertDialog(context, "Please Enter Your Email");
    }
    if (uPassword.isEmpty) {
      MyAlertDialog(context, "Please Enter Password");
    } else {
      await DBHelper.getUserInfo(uEmail, uPassword).then(
        (userData) {
          if (userData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VisitList(),
              ),
            );
          } else {
            MyAlertDialog(context, "Error: User Not Found");
          }
        },
      ).catchError(
        (error) {
          print(error);
          MyAlertDialog(context, "Error: Login Fail");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Welcome To Travel Planner'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter correct email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter correct password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyRegistration(),
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      onPressed: () {
                        login();
                      },
                      child: const Text('Log In'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
