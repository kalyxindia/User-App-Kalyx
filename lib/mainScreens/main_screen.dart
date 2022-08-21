import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:userapp/assistants/assistant_methods.dart';
import 'package:userapp/global/global.dart';
import 'package:userapp/infoHandler/app_info.dart';
import 'package:userapp/mainScreens/search_places_screen.dart';
import 'package:userapp/splashScreen/splash_screen.dart';
import 'package:userapp/widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;

  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  double searchLoctionContainerHeight = 220;
  double bottomPaddingOfMap = 0;

  checkIfPermissionAllowed() async
  {
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async
  {

    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 18);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeoCoordinates(userCurrentPosition!,context);

    print("Address = "+humanReadableAddress);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userModelCurrentInfo!.name,
            email: userModelCurrentInfo!.email,
          ),
        ),
      ),
      body: Stack(
        children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController googleMapController)
              {
               _controller.complete(googleMapController);
               newGoogleMapController = googleMapController;

               blackThemeGoogleMap();

               setState(() {
                 bottomPaddingOfMap = 245;
               });

               locateUserPosition();
              },
            ),

            //Custom Hamburger Button
            Positioned(
                top: 30,
                left: 18,
                child: GestureDetector(
                  onTap: (){
                      sKey.currentState!.openDrawer();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                     Icons.menu,
                     color: Colors.black54,
                    ),
                  ),
                )
            ),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  height: searchLoctionContainerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.add_location_alt_outlined,color: Colors.grey,),
                            const SizedBox(width: 12.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const Text(
                                    "From",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                    ),
                                  ),
                                  Text(
                                    Provider.of<AppInfo>(context).userPickUpLocation != null
                                        ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                                        : "Your Current Location",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                    ),
                                  )
                                ],
                            )
                          ],
                        ),

                        SizedBox(height: 10,),

                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 16,),

                        GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => SearchPlacesSCreen() ));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.add_location_alt_outlined,color: Colors.grey,),
                              const SizedBox(width: 12.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "To",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                    ),
                                  ),
                                  Text(
                                    "Where To Go?",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 10,),

                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 16,),

                        ElevatedButton(
                            onPressed: (){

                            },
                            child: Text(
                              "Request A Ride"
                            ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)

                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          )

        ],
      ),
    );
  }

  blackThemeGoogleMap(){
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

}
