import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'pagesView_bodies/4-address_page/provider.dart';

class MapVV extends StatelessWidget {
  final AddressPageProvider provider;

  const MapVV(
    this.provider, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            onMapCreated: provider.getMapController1,
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                41.30943824734748,
                69.24100778996944,
              ),
              zoom: 10,
            ),
            onTap: (latLng) {
              provider.updateMapMarkerPosition(latLng);
              provider.chooseLocation(latLng);
            },
            markers: provider.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            buildingsEnabled: false,
          ),
        ),
      ],
    );
  }
}
