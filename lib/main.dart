import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/infoHandler/app_info.dart';
import 'package:userapp/splashScreen/splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyHomePage(
    child : ChangeNotifierProvider(
    create: (context) => AppInfo(),
    child: MaterialApp(
      title: 'Drivers App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  MySplashScreen(),//Scaffold(appBar: AppBar(title: Text("Welcome to Drivers App"),),),
      debugShowCheckedModeBanner: false,
    ),
  )
  ));
}

class MyHomePage extends StatefulWidget {
  final Widget? child;

  MyHomePage({this.child});

  static void restartApp(BuildContext context){
    context.findAncestorStateOfType<_MyHomePageState>()!.restartApp();
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return KeyedSubtree(
        key: key,
        child: widget.child!
    );
  }
}
