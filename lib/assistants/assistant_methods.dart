import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:userapp/assistants/request_assistant.dart';
import 'package:userapp/global/global.dart';
import 'package:userapp/global/map_key.dart';
import 'package:userapp/infoHandler/app_info.dart';
import 'package:userapp/models/directions.dart';
import 'package:userapp/models/user_model.dart';

class AssistantMethods{

  static Future<String> searchAddressForGeoCoordinates(Position position,context) async
  {
    String apiUrl = "https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=$reverseGeoApiKey";
    var requestResponse =  await RequestAssistants.receiveRequest(apiUrl);
    String humanReadableAddress = "";
   if(requestResponse != "Error Occurred, Failed. No Response.")
     {
       humanReadableAddress = requestResponse["features"][0]["properties"]["formatted"];

       Directions userPickUpAddress = Directions();

       userPickUpAddress.locationLatitude = position.latitude;
       userPickUpAddress.locationLongitude = position.longitude;
       userPickUpAddress.locationName = humanReadableAddress;

       Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
     }


   return humanReadableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentDFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
                                .ref()
                                .child("users")
                                .child(currentDFirebaseUser!.uid);

    userRef.once().then((snap) {
      if(snap.snapshot.value != null){
       userModelCurrentInfo =  UserModel.fromSnapShot(snap.snapshot);
       print("name = " + userModelCurrentInfo!.name.toString());
       print("email = " + userModelCurrentInfo!.email.toString());
       print("phone = " + userModelCurrentInfo!.phone.toString());
      }
    });

  }

}