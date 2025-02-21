import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInMap extends StatefulWidget {
  final DocumentSnapshot<Object?> place;
  const LocationInMap({
    super.key,
    required this.place,
  });

  @override
  State<LocationInMap> createState() => _LocationInMapState();
}

class _LocationInMapState extends State<LocationInMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
  myLocationButtonEnabled: false,
  markers: <Marker>{
        Marker(
          markerId: MarkerId(widget.place['address'] ?? "Unknown Location"),
          position: LatLng(
            widget.place['latitude'] ?? 0.0,
            widget.place['longitude'] ?? 0.0,
          ),
        ),
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.place['latitude'] ?? 0.0,
          widget.place['longitude'] ?? 0.0,
        ),
        zoom: 11,
      ),
    );

  }
}










































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationInMap extends StatefulWidget {
//   final DocumentSnapshot<Object?> place;
//   const LocationInMap({
//     super.key,
//     required this.place,
//   });

//   @override
//   State<LocationInMap> createState() => _LocationInMapState();
// }

// class _LocationInMapState extends State<LocationInMap> {

//   static const double _defaultLat = 37.7749;
//   static const double _defaultLng = -122.4194;

//   static const CameraPosition _defaultLocation = CameraPosition(
//     target: LatLng(_defaultLat, _defaultLng), zoom: 15);

//     late final GoogleMapController _googleMapController;
//     MapType _currentMapType = MapType.normal;
//     final Set<Marker> _markers = {};

//   void _changeMapType(){
//     setState(() {
//       _currentMapType=_currentMapType == MapType.normal
//       ? MapType.satellite 
//       : MapType.normal;
//     });
//   }

//   void _addMarker(){
//     setState(() {
//       _markers.add(
//         Marker(markerId: MarkerId('defaultLocation'),
//         position: _defaultLocation.target,
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Really cool Place',
//           snippet: '5 star Rating'),
//         ));
//   });

//   }

// Future <void> _moveToNewLocation() async {
//   const _newPosition = LatLng(40.7128, -74.0060);
//   _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(_newPosition, 15));

//   setState(() {
//     const marker = Marker(markerId: MarkerId('newLocation'),
//     position: _newPosition,
//     infoWindow: InfoWindow(title: 'New York', snippet: 'Best Plca'));
 

//   _markers
//   ..clear()
//   ..add(marker);
//  });

// }
// Future <void> _goToDefaultLocation() async {
//   const _defaultPosition = LatLng(_defaultLat,_defaultLng);
//   _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(_defaultPosition, 15));


//     setState(() {
//     const marker = Marker(markerId: MarkerId('My Default Location'),
//     position: _defaultPosition,
//     infoWindow: InfoWindow(title: 'Home', snippet: 'Best Place'));
 

//   _markers
//   ..clear()
//   ..add(marker);
//  });


// }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//      appBar: AppBar(
//       title: const Text('Google Map'),
//      ),
//      body:Stack(children: <Widget> [
//        GoogleMap(
//       onMapCreated: (controller) => _googleMapController = controller,
//       initialCameraPosition: _defaultLocation,
//       mapType: _currentMapType,
//       markers: _markers,
    
//     ),
//     const SizedBox(height: 20.0,),
//     FloatingActionButton(
//       onPressed: _changeMapType,
//       child: const Icon(Icons.map,size:30.0)),
//     FloatingActionButton(onPressed: _addMarker,
//     child: const Icon(Icons.add_location,size:30.0)),
//     FloatingActionButton(onPressed: _moveToNewLocation),
//     FloatingActionButton(onPressed: _goToDefaultLocation,
//     child: const Icon(Icons.home_rounded,size: 36.0,),)

//      ],
//      ));
    
    
    
//   }


