
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userapp/authentication/signup_screen.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  validateForm()
  {
   if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast( msg: "Not Valid Email");
    }else if(passwordEditingController.text.isEmpty){
      Fluttertoast.showToast( msg: "Password is required");
    }else{
     loginUser();
    }
  }

  loginUser() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Please Wait");
        }
    );

    final User? firebaseUser = (
        await firebaseAuth.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordEditingController.text.trim()
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser!=null){

      DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users");

      databaseReference.child(firebaseUser.uid).once().then((driverKey)
      {
        final snap = driverKey.snapshot;

        if(snap.value!=null){
          currentDFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }else{
          Fluttertoast.showToast(msg: "No Record Exist with this email");
          firebaseAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }

      });

    }else{

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Login Failed");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Login As User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Email",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    )
                ),
              ),

              TextField(
                controller: passwordEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                    )
                ),
              ),

              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  )),

              TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpScreen()));
                  },
                  child: const Text("Do Not Have An Account? SignUp Here",
                  style: TextStyle(color: Colors.grey),))

            ],
          ),
        ),
      ),
    );
  }
}
