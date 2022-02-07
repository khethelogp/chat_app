import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // const AuthForm({ Key? key }) : super(key: key);
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
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

  var _userImageFile;

  void _pickedImage(File image){
    _userImageFile = image;
  } 

  void _trySubmit() {
    var isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if(_userImageFile == null && !_isLogin){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      return;
    }

    if(isValid == true) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context
      );
      
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
                    if(!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
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
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
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
                    FlatButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      color: Theme.of(context).primaryColor,
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