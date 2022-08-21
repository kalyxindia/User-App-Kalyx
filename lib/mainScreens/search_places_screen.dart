import 'package:flutter/material.dart';

class SearchPlacesSCreen extends StatefulWidget {

  @override
  State<SearchPlacesSCreen> createState() => _SearchPlacesSCreenState();
}

class _SearchPlacesSCreenState extends State<SearchPlacesSCreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 25.0,),
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.black54,
              boxShadow:
                [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7
                    )
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Stack(
                    children: [

                     const SizedBox(height: 25.0,),

                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                      ),

                      Center(
                        child: Text(
                          "Search & Set DropOff Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )

                    ],
                  ),
                  const SizedBox(height: 16.0,),

                  Row(
                    children: [
                      const Icon(
                        Icons.adjust_sharp,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 18.0,),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (valueTyped)
                        {

                        },
                        decoration: const InputDecoration(
                          hintText: "Search Here...",
                          fillColor: Colors.white54,
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 11.0,
                            top: 8.0,
                            bottom: 8.0,
                          )
                        ),
                      ),
                    ),
                  )
                    ],
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
