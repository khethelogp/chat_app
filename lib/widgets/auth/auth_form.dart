import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // const AuthForm({ Key? key }) : super(key: key);
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    var isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if(isValid == true) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(), 
        _isLogin,
        context
      );
      // print(_userEmail);
      // print(_userName);
      // print(_userPassword);
      
      //! send auth request ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if(value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value){
                        _userEmail = value!;
                      },
                    ),
                    if(!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if(value!.isEmpty || value.length < 4) {
                          return 'Please enter atleast 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value){
                        _userName = value!;
                      },
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if(value!.isEmpty || value.length < 7) {
                          return 'Password must be atleast 7 charcters long.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onSaved: (value){
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(height: 12,),
                    if(widget.isLoading)
                      CircularProgressIndicator(),
                    if(!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit, 
                    ),
                    if(!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                      onPressed: (){
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      }, 
                    )
                  ],
                ),
              )
            ),
          ),
        ),
    );
  }
}