import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:airbnb_app_ui/model/place_model.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'icon_button.dart';

class MapWithCustonInfoWindows extends StatefulWidget {
  const MapWithCustonInfoWindows({super.key});

  @override
  State<MapWithCustonInfoWindows> createState() =>
      _MapWithCustonInfoWindowsState();
}

class _MapWithCustonInfoWindowsState extends State<MapWithCustonInfoWindows> {
  LatLng myCurrentLocation = const LatLng(27.7172, 85.3240);
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  Map<String, Marker> markers = {};
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    // Load your custom marker icon if needed
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      "asset/images/marker.png",
      height: 40,
      width: 30,
    );

    // Iterate over the list of places and add markers

    // ignore: use_build_context_synchronously
    Size size = MediaQuery.of(context).size;

    for (var place in listOfPlace) {
      final marker = Marker(
        markerId: MarkerId(place.address),
        position: LatLng(place.latitude, place.longitude),
        onTap: () {
          // When marker is tapped, show the custom info window
          _customInfoWindowController.addInfoWindow!(
            Container(
              height: size.height * 0.32,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(place.image),
                              fit: BoxFit.cover),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        height: size.height * 0.203,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          child: AnotherCarousel(
                            images: place.imageUrls
                                .map((url) => NetworkImage(url))
                                .toList(),
                            dotSize: 5,
                            indicatorBgPadding: 5.0,
                            dotBgColor: Colors.transparent,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 14,
                        right: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Guest Favorite",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                         const  Spacer(),
                            const MyIconButton(
                                icon: Icons.favorite_border, radius: 15),
                            const SizedBox(width: 13),
                            InkWell(
                              onTap: () {
                                _customInfoWindowController
                                    .hideInfoWindow!(); // Hide only the custom info window
                              },
                              child: const MyIconButton(
                                  icon: Icons.close, radius: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              place.address,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.star),
                            const SizedBox(width: 5),
                            Text(place.rating.toString())
                          ],
                        ),
                        const Text(
                          "3066 m elevation",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          place.date,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "\$${place.price} ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            children: const [
                              TextSpan(
                                text: "night",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            LatLng(place.latitude, place.longitude),
          );
        },
        icon: customIcon,
      );
      markers[place.address] = marker;
    }

    // Update the state to show the markers on the map
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {
        showModalBottomSheet(
          clipBehavior: Clip.none,
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              height: size.height * 0.77,
              width: size.width,
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height * 0.77,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: myCurrentLocation,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        googleMapController = controller;
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      onTap: (argument) {
                        // Hide the custom info window when the map is tapped
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        // Update the position of the custom info window when the camera moves
                        _customInfoWindowController.onCameraMove!();
                      },
                      markers: markers.values.toSet(),
                    ),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: size.height * 0.34,
                    width: size.width * 0.85,
                    offset:
                        50 // Offset to position the info window above the marker
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 170, vertical: 5),
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      label: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            SizedBox(width: 5),
            Text(
              "Map",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.map_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
