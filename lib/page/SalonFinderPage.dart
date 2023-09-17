import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../controller/SalonFinderMap.dart';

class SalonFinderPage extends StatelessWidget {
  final SalonFinderMap controller = Get.put(SalonFinderMap());

  SalonFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Finder'),
      ),
      body: FutureBuilder(
        future: controller.mapController,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          //
          // }
          // else {
          return GoogleMap(

            onMapCreated: controller.onMapCreated,
            initialCameraPosition:
            CameraPosition(
              target: controller.center!,
              zoom: 25.0,
            ),
            markers: controller.markers,
            mapType: MapType.normal, // Use normal map type
          );
          // }
        },
      ),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.white,
    //   onPressed: (){
    //       print("pressed");
    //     controller.getCurrentLocation();
    //     },
    //   tooltip: 'Get Current Location',
    //
    //   child: const Icon(Icons.my_location,color: Colors.blue,),
    // ),
    );
  }
}