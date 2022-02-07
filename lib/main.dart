import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        )
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshhot) {
          if(userSnapshhot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          if(userSnapshhot.hasData) {
            return ChatScreen();
          }

          return const AuthScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
      // home: AuthScreen()
    );
  }
}

class HomeScreen extends StatelessWidget {
  // const HomeScreen({ Key? key }) : super(key: key);
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud firestore data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Read Data from cloud firestore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: users, 
                builder: (
                  BuildContext context, 
                  AsyncSnapshot<QuerySnapshot> snapshot
                ) {
                  if(snapshot.hasError) {
                    return Text('Somthing went wrong.');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }


                  final data = snapshot.requireData;
                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (ctx, index) {
                      return Text('My name is ${data.docs[index]['name']} and I am ${data.docs[index]['age']}.');
                    },
                  );

                },
              ),
            ),
            Text(
              'Write data to cloud firestore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            MyCustomForm()
          ],
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  var name = '';
  var age = 0;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What\'s your name?',
              labelText: 'Name'
            ),
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if(value == null || value.isEmpty) {
                return 'Please enter some text';
              }

              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'What\'s your age?',
              labelText: 'Age'
            ),
            onChanged: (value) {
              age = value as int;
            },
            validator: (value) {
              if(value == null || value.isEmpty) {
                return 'Please enter some text';
              }

              return null;
            },
          ),
          SizedBox(height: 10,),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sending data to cloud firefox') 
                    )
                  );

                  users.add({
                    'name': name,
                    'age': age
                  }).then((value) => print('user addded')).catchError((error) => print('there was an error'));
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      )
    );
  }
}
