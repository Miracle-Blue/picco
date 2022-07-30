import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picco/models/address_model.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

import 'view.dart';

final AddressPageProvider addressPageProvider = AddressPageProvider();

class AddressPageProvider extends ChangeNotifier {
  AddressPageProvider() {
    fetchData();
    Log.d("message");
  }

  TextEditingController streetTextController = TextEditingController();

  bool isActiveStreetTextField = false;
  bool isDisabled = true;
  bool hiddenWidget = true;

  Address regionAddress = Address();
  Address districtAddress = Address();

  dynamic listDistricts = [];

  bool onTapPutHouseLocation = false;

  Future<void> fetchData() async {
    dynamic _regions = await FirebaseFirestore.instance
        .collection("address")
        .doc("region")
        .get();
    dynamic _districts = await FirebaseFirestore.instance
        .collection("address")
        .doc("district")
        .get();
    regionAddress = Address.fromJsonRegions(_regions.data()!);
    districtAddress = Address.fromJsonDistricts(_districts.data()!);
    listDistricts = districtAddress.districts[0][regionAddress.regions[0]];
    notifyListeners();

    region = regionAddress.regions[0];
    city = (districtAddress.districts[0] as Map<String, dynamic>).keys.first;

    await onSelectGetLocation(location: '$city, $region');

    notifyListeners();
  }

  String city = '';
  String region = '';
  String street = '';

  void onSubmit() {
    uploadIsActiveStreetTextField(true);
    addressPageProvider.street = streetTextController.text;

    notifyListeners();
  }

  void onChange() {
    street = streetTextController.text;
    notifyListeners();
  }

  double lat = 0;
  double lng = 0;

  final completer1 = Completer<GoogleMapController>();
  final completer2 = Completer<GoogleMapController>();

  void getMapController1(GoogleMapController controller) {
    completer1.complete(controller);
  }

  void getMapController2(GoogleMapController controller) {
    completer2.complete(controller);
  }

  /// * map Marker
  final Set<Marker> markers = {};

  /// * for updating map show marker
  void updateMapMarkerPosition(LatLng latLng) {
    if (markers.isNotEmpty) {
      markers.clear();
    }

    Log.e('${latLng.latitude}  ${latLng.longitude}');

    markers.add(Marker(
      markerId: const MarkerId('get_home_location'),
      position: LatLng(latLng.latitude, latLng.longitude),
      icon: BitmapDescriptor.defaultMarker,
    ));
    notifyListeners();
  }

  updateOnTapPutHouseLocation() {
    onTapPutHouseLocation = true;
    notifyListeners();
  }

  uploadIsActiveStreetTextField(bool value) {
    isActiveStreetTextField = value;
    notifyListeners();
  }

  void chooseOption(String option, String label, BuildContext context) async {
    switch (label) {
      case 'Область':
        city = option;
        listDistricts = districtAddress
            .districts[regionAddress.regions.indexOf(city)][city];
        addressPageProvider.city = city;
        notifyListeners();
        break;
      case 'Район/Город':
        region = option;
        addressPageProvider.region = region;
        notifyListeners();
        break;
      default:
        break;
    }

    await onSelectGetLocation(location: '$city, $region');
  }

  Future<void> onSelectGetLocation({required String location}) async {
    late List<Location> locations;

    try {
      locations = await locationFromAddress(location);

      Log.d('${locations.first.latitude} ${locations.first.longitude}');

      addressPageProvider.chooseLocation(
        LatLng(locations.first.latitude, locations.first.longitude),
      );

      addressPageProvider.updateMapMarkerPosition(
        LatLng(locations.first.latitude, locations.first.longitude),
      );
    } catch (e) {
      addressPageProvider.chooseLocation(
        LatLng(locations.first.latitude, locations.first.longitude),
      );

      addressPageProvider.updateMapMarkerPosition(
        LatLng(locations.first.latitude, locations.first.longitude),
      );
    }
  }

  void updateButtonDisability(bool _isDisabled) {
    isDisabled = _isDisabled;
    notifyListeners();
  }

  void chooseLocation(LatLng latLng) {
    lat = latLng.latitude;
    lng = latLng.longitude;
    notifyListeners();
  }

  Future<void> showBottomSheet(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const BottomSheetContentInAddress(),
    );
  }

  void openMapPage(
    BuildContext context,
    AddressPageProvider provider,
  ) async {
    final geo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressMapView(),
      ),
    );

    if (geo != null) hiddenWidget = false;
    notifyListeners();

    if (geo != null && geo is LatLng) {
      addressPageProvider.chooseLocation(geo);

      final mapController = await completer1.future;

      updateMapMarkerPosition(geo);

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: geo,
            zoom: 14,
          ),
        ),
      );
    }
  }
}

class AddressMapView extends StatelessWidget {
  const AddressMapView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressPageProvider(),
      builder: (context, child) {
        final provider = context.watch<AddressPageProvider>();
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: provider.getMapController2,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    addressPageProvider.lat,
                    addressPageProvider.lng,
                  ),
                  zoom: 14,
                ),
                onTap: (latLng) {
                  provider.updateMapMarkerPosition(latLng);
                  provider.chooseLocation(latLng);
                  provider.updateOnTapPutHouseLocation();
                },
                markers: provider.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                buildingsEnabled: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 20.w),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    padding: EdgeInsets.zero,
                    minimumSize: Size(40.h, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
          floatingActionButton: provider.onTapPutHouseLocation
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context, LatLng(provider.lat, provider.lng));
                  },
                  child: const Icon(CupertinoIcons.checkmark),
                )
              : null,
        );
      },
    );
  }
}
