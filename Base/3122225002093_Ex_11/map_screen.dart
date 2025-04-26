import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'location_service.dart';
import 'route_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = LatLng(37.7749, -122.4194); // Default: San Francisco
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId("defaultLocation"),
        position: _initialPosition,
        infoWindow: InfoWindow(title: "Default Location"),
      ),
    );
  }

  void _searchLocation(String query) async {
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      LatLng searchedLocation = LatLng(locations.first.latitude, locations.first.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(searchedLocation));

      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId("searchedLocation"),
          position: searchedLocation,
          infoWindow: InfoWindow(title: query),
        ));
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await LocationService.getCurrentLocation();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId("currentLocation"),
        position: currentLatLng,
        infoWindow: InfoWindow(title: "Your Location"),
      ));
    });
  }

  void _getRoute(String start, String end) async {
    Set<Polyline> polylines = await RouteService.getRoute(start, end);
    setState(() {
      _polylines = polylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps App")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: "Search Location"),
                    onSubmitted: _searchLocation,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 12.0),
              onMapCreated: (controller) => mapController = controller,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: _getCurrentLocation,
      ),
    );
  }
}
