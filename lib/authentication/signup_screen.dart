import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userapp/authentication/login_screen.dart';
import 'package:userapp/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  //TextEditingController textEditingController = TextEditingController();

  validateForm()
  {
    if(nameTextEditingController.text.length<3){
      Fluttertoast.showToast( msg: "Username should not empty!");
    }else if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast( msg: "Not Valid Email");
    }else if(phoneTextEditingController.text.isEmpty){
      Fluttertoast.showToast( msg: "Phone number is required");
    }else if(passwordEditingController.text.length < 6){
      Fluttertoast.showToast( msg: "Password must be atleast 6 characters!");
    }else{
      saveUserInfo();
    }
  }

  saveUserInfo() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Please Wait");
        }
    );

    final User? firebaseUser = (
        await firebaseAuth.createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordEditingController.text.trim()
        ).catchError((msg){
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser!=null){

      Map userMap = {
        "id":firebaseUser.uid,
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "phone":phoneTextEditingController.text.trim()
      };

      DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users");
      databaseReference.child(firebaseUser.uid).set(userMap);

      currentDFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been created");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));

    }else{

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [

              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/car.png"),
              ),

              const SizedBox(height: 10,),

              const Text(
                "Register As An User",
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              ),

              TextField(
                controller: nameTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                    labelText: "Phone",
                    hintText: "Phone",
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
                    "Create Account",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18
                    ),
                  )),

              TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                  },
                  child: const Text("Already Have An Account? Login Here",
                    style: TextStyle(color: Colors.grey),))

            ],
          ),
        ),
      ),
    );
  }
}
