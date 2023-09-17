import 'dart:async';
import 'dart:math';
//import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/salon.dart';

class SalonFinderMap extends GetxController {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? center =LatLng(37.7749, -122.4194); // Default center (San Francisco).
  final Set<Marker> markers = {};

  @override
  void onInit() {
    super.onInit();

    // getCurrentLocation();
    generateDemoSalons();
  }


  void generateDemoSalons() {
    final salons = <Salon>[];
    final Random random = Random();
    const int numberOfSalons = 10; // Adjust the number of salons as needed.

    // Create a different marker for your location (e.g., blue)
     Marker myLocationMarker = Marker(
      markerId: const MarkerId('MyLocation'),
      position: center!,
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Change the hue to change the color
    );

    // Add your location marker to the markers set
    markers.add(myLocationMarker);

    for (int i = 0; i < numberOfSalons; i++) {
      final double latOffset = (random.nextDouble() * 10 - 5) / 111.32; // ~5 km in latitude
      final double lngOffset =
          (random.nextDouble() * 5 - 2) / (111.32 * cos(center!.latitude * pi / 180.0)); // ~5 km in longitude
      final LatLng salonLocation = LatLng(center!.latitude + latOffset, center!.longitude + lngOffset);

      salons.add(Salon("Salon $i", salonLocation));
    }

    // Create a different marker for salons (e.g., red)
    final List<Marker> salonMarkers = salons.map((salon) {
      return Marker(
        markerId: MarkerId(salon.name),
        position: salon.location,
        infoWindow: InfoWindow(title: salon.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet), // Change the hue to change the color
      );
    }).toList();

    // Add salon markers to the markers set
    markers.addAll(salonMarkers);

    update();
  }


  // void generateDemoSalons() {
  //   final salons = <Salon>[];
  //   final Random random = Random();
  //   const int numberOfSalons = 5; // Adjust the number of salons as needed.
  //
  //   for (int i = 0; i < numberOfSalons; i++) {
  //     final double latOffset = (random.nextDouble() * 10 - 5) / 111.32; // ~5 km in latitude
  //     final double lngOffset =
  //         (random.nextDouble() * 10 - 5) / (111.32 * cos(center.latitude * pi / 180.0)); // ~5 km in longitude
  //     final LatLng salonLocation = LatLng(center.latitude + latOffset, center.longitude + lngOffset);
  //
  //     salons.add(Salon("Salon $i", salonLocation));
  //   }
  //
  //   markers.addAll(salons.map((salon) {
  //     return Marker(
  //       markerId: MarkerId(salon.name),
  //       position: salon.location,
  //       infoWindow: InfoWindow(title: salon.name),
  //     );
  //   }));
  //
  //   update();
  // }

  Future<void> onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    await loadMapStyle();
  }

  void onSearchPressed() {
    // Add logic here to search for nearby salons using geocoding.
  }

  Future<GoogleMapController> get mapController => _mapController.future;

  Future<void> loadMapStyle() async {
    final String style = await rootBundle.loadString('assets/map_style_black.json');
    final GoogleMapController controller = await mapController;
    controller.setMapStyle(style);
  }
  //
  // getCurrentLocation() async {
  //   print("location");
  //   try {   //markers.clear();
  //           Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.high,
  //           );
  //           center = LatLng(position.latitude, position.longitude);
  //           print("latitude: ${position.latitude} longitude: ${position.longitude}");
  //        //   generateDemoSalons();
  //
  //           update();
  //         } catch (e) {
  //           print("Error getting location: $e");
  //         }
  // }
}