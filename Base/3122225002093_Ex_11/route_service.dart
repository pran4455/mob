import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteService {
  static const String _apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

  static Future<Set<Polyline>> getRoute(String start, String end) async {
    List<Location> startLocation = await locationFromAddress(start);
    List<Location> endLocation = await locationFromAddress(end);

    LatLng startLatLng = LatLng(startLocation.first.latitude, startLocation.first.longitude);
    LatLng endLatLng = LatLng(endLocation.first.latitude, endLocation.first.longitude);

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _apiKey,
      PointLatLng(startLatLng.latitude, startLatLng.longitude),
      PointLatLng(endLatLng.latitude, endLatLng.longitude),
    );

    Set<Polyline> polylines = {};
    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates =
      result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();

      polylines.add(Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));
    }

    return polylines;
  }
}
