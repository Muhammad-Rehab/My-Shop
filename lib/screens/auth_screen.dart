import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_shop/providers/auth.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.deepOrange.shade500,
                Colors.greenAccent,
                Colors.yellow.shade500.withOpacity(.8)
              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
            ),
          ),
          Container(
            height: (deviceSize.height - MediaQuery.of(context).padding.top),
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height * .2),
                left: 10,
                right: 10,
                bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: deviceSize.height * .10,
                      width: deviceSize.width * .8,
                      transform: Matrix4.rotationZ(-10 * (pi / 180)),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: Offset(-15, 15),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'My Shop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * .02,
                  ),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { LogIn, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var _authMode = AuthMode.LogIn;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _passwordController = TextEditingController();

   late Animation<double>  _opacityAnimation ;


  @override
  void initState() {
    _opacityAnimation = Tween<double>(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    ), curve: Curves.linear));
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).authMethod(
        _authData['email'] ?? '',
        _authData['password'] ?? '',
        _authMode == AuthMode.LogIn,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(e.toString()),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Card(
      color: Colors.white70,
      elevation: 15,
      shadowColor: Colors.black.withOpacity(.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: deviceSize.width * .8,
        height: (_authMode == AuthMode.SignUp) ? 360 : 300,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'ahmed30@gmail.com',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.yellow,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (!value!.contains('@gmail.com')) {
                      return 'Email should contain @gmail.com';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value ?? '';
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Colors.yellow),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.length <= 5) {
                      return 'Password is too short';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value ?? '';
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: (_authMode == AuthMode.SignUp)? 60: 0 ,
                    maxHeight: (_authMode == AuthMode.SignUp)? 120 :0 ,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation  ,
                    child:  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: (_authMode == AuthMode.SignUp)? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ): null ,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text ) {
                          return 'Password is not match';
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (_isLoading) CircularProgressIndicator(),
                if (!_isLoading)
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(
                      _authMode == AuthMode.LogIn ? 'LOG IN' : 'SIGN UP',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.yellow.shade900,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                if (!_isLoading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode == AuthMode.SignUp
                            ? _authMode = AuthMode.LogIn
                            : _authMode = AuthMode.SignUp;
                      });
                    },
                    child: Text(
                      '${_authMode == AuthMode.SignUp ? 'Login In' : 'Sign Up'} Instead',
                      style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 18,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
