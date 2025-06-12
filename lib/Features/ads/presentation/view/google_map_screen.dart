import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  final LatLng _initialPosition = const LatLng(30.0444, 31.2357); // Cairos
  final Set<Marker> _markers = {};
  bool _mapSupported = true;
  LatLng? _selectedPosition;

  void _goToPlace(String place) async {
    try {
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedPosition = latLng;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId(place),
              position: latLng,
              infoWindow: InfoWindow(title: place),
            ),
          );
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 14),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not find location")),
      );
    }
  }

  Future<void> _setCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _selectedPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: _selectedPosition!,
          infoWindow: const InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _selectedPosition!, zoom: 15),
      ),
    );
  }

  Future<Map<String, dynamic>?> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = "${place.street}, ${place.locality}, ${place.country}";
        return {
          'lat': position.latitude,
          'lng': position.longitude,
          'address': address,
        };
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return {
      'lat': position.latitude,
      'lng': position.longitude,
      'address': null,
    };
  }

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _setCurrentLocation,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (_selectedPosition != null) {
            final locationData =
                await _getAddressFromLatLng(_selectedPosition!);
            Navigator.pop(context, locationData);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a location")),
            );
          }
        },
      ),
      body: _mapSupported
          ? Stack(
              children: [
                Builder(
                  builder: (context) {
                    try {
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: _selectedPosition ?? _initialPosition,
                            zoom: 10),
                        onMapCreated: (controller) =>
                            mapController = controller,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: _markers,
                        onTap: (LatLng position) {
                          setState(() {
                            _selectedPosition = position;
                            _markers.clear();
                            _markers.add(
                              Marker(
                                markerId: MarkerId("selected_location"),
                                position: position,
                                infoWindow: const InfoWindow(
                                    title: "Selected Location"),
                              ),
                            );
                          });
                        },
                      );
                    } catch (e) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => _mapSupported = false);
                      });
                      return Container();
                    }
                  },
                ),
                // Builder(
                //   builder: (context) {
                //     try {
                //       return GoogleMap(
                //         initialCameraPosition: CameraPosition(
                //           target: _selectedPosition ?? _initialPosition,
                //           zoom: 10,
                //         ),
                //         onMapCreated: (controller) =>
                //             mapController = controller,
                //         myLocationEnabled: true,
                //         myLocationButtonEnabled: true,
                //         markers: _markers,
                //         onTap: (LatLng position) async {
                //           setState(() {
                //             _selectedPosition = position;
                //             _markers.clear();
                //           });

                //           String placeName = await _getPlaceName(position);

                //           setState(() {
                //             _markers.add(
                //               Marker(
                //                 markerId: const MarkerId("selected_location"),
                //                 position: position,
                //                 infoWindow: InfoWindow(title: placeName),
                //               ),
                //             );
                //           });
                //         },
                //       );
                //     } catch (e) {
                //       WidgetsBinding.instance.addPostFrameCallback((_) {
                //         setState(() => _mapSupported = false);
                //       });
                //       return Container();
                //     }
                //   },
                // ),

                Positioned(
                  top: 10,
                  left: 15,
                  right: 15,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for a place',
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => _goToPlace(_searchController.text),
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _goToPlace,
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                "This device does not support Google Maps",
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  // Future<String> _getPlaceName(LatLng latLng) async {
  //   try {
  //     final placemarks = await placemarkFromCoordinates(
  //       latLng.latitude,
  //       latLng.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       return place.name ?? "Unnamed place";
  //     } else {
  //       return "Unknown place";
  //     }
  //   } catch (e) {
  //     return "Error getting place name";
  //   }
  // }
}
