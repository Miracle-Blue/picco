import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picco/customer/view/pages/search/search_page.dart';

import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/city_default_location_model.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/models/place_model.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/location_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'map_widgets/flutter_widget_to_image.dart';
import 'map_widgets/home_snackbar_element.dart';
import 'map_widgets/marker_template_widget.dart';

class SearchPageInherit extends InheritedNotifier<SearchProvider> {
  const SearchPageInherit({
    Key? key,
    required SearchProvider model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static SearchProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SearchPageInherit>()
        ?.notifier;
  }

  static SearchProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<SearchPageInherit>()
        ?.widget;
    return widget is SearchPageInherit ? widget.notifier : null;
  }
}

class SearchProvider extends ChangeNotifier {
  final textEditingController = TextEditingController(
    text: HiveService.loadString("city"),
  );

  final favoriteHouseFolderNameController = TextEditingController();

  List favoriteHouses = [];

  PlaceModel? placeModel;
  final focusNode = FocusNode();
  bool showAutoFeel = false;

  // map
  Set<Marker> markers = {};
  Set<Marker> markersWhiteNotTapped = {};
  Set<Marker> markersBlackTapped = {};
  Widget bottomHomeElement = const SizedBox.shrink();
  late final Completer<GoogleMapController> completer = Completer();
  final snappingSheetController = SnappingSheetController();

  /// * for map Initial value
  String sellType = '';
  String categoryType = '';
  String city = '';

  Future<void> loadFavoriteHouses(String userId) async {
    Log.w("Load favorite houses !!!!!!!!!");
    await FirestoreService.getFavoriteHouses(userId).then((json) {
      favoriteHouses = json ?? [];
      favoriteObject.list = json ?? [];
    });
    notifyListeners();
  }

  createNewFavoriteHouseProvider(HomeModel home) {
    favoriteHouses.add({
      favoriteHouseFolderNameController.text.trim(): [home.toJson()]
    });
    favoriteObject.list = favoriteHouses;
    notifyListeners();
  }

  addNewFavoriteHouseToFolder(String folderName, HomeModel home) {
    for (var folder in favoriteHouses) {
      if (folder.keys.first == folderName) {
        folder.values.first.add(home.toJson());
        notifyListeners();
        break;
      }
    }
    favoriteObject.list = favoriteHouses;
  }

  bool favoriteHouseIsLike(String houseID) {
    Log.w("favoriteHouseIsLike");
    if (favoriteHouses.isNotEmpty) {
      for (var folder in favoriteHouses) {
        for (Map<String, dynamic> house in folder.values.first) {
          if (house["id"] == houseID) {
            return true;
          }
        }
      }
    }

    return false;
  }

  void removeHouseFromFavorite(String houseID) {
    output:
    for (var folder in favoriteHouses) {
      for (Map<String, dynamic> houses in folder.values.first) {
        if (houses["id"] == houseID) {
          folder.values.first.remove(houses);
          if (folder.values.first.isEmpty) {
            favoriteHouses.remove(folder);
          }
          notifyListeners();
          break output;
        }
      }
    }
    FirestoreService.storeFavoriteFolders(favoriteHouses);
    favoriteObject.list = favoriteHouses;
  }

  disposeFavoriteHouses() async {
    await FirestoreService.storeFavoriteFolders(favoriteHouses);
    Log.i("dispose!!!!!!!! Search page");
  }

  Future<void> getHousesFromFirebase() async {
    homes = await FirestoreService.getCountryHouses(
      sellType: 'buy_houses',
      categoryType: 'house',
    );
    notifyListeners();

    for (var element in homes) {
      Log.e(element.toString());
    }
  }

  void input(String input) async {
    var response = await LocationService.GET(
      LocationService.API_PLACE,
      LocationService.paramsSearch(text: input),
    );

    if (response != null) {
      showAutoFeel = true;
      placeModel = placeModelFromJson(response);
      notifyListeners();
    }
  }

  Future<void> onSelectedLocationMoveCamera({
    required String location,
    required BuildContext context,
  }) async {
    textEditingController.text = location;
    focusNode.unfocus();
    showAutoFeel = false;
    notifyListeners();

    late List<Location> locations;

    try {
      locations = await locationFromAddress(location);

      Log.d('${locations.first.latitude} ${locations.first.longitude}');

      final mapController = await completer.future;

      markers.add(Marker(
        markerId: const MarkerId('user_searched_location'),
        position: LatLng(
          locations.first.latitude,
          locations.first.longitude,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locations.first.latitude,
              locations.first.longitude,
            ),
            zoom: 14.6,
          ),
        ),
      );
    } catch (e) {
      Utils.fireSnackBar(
        normalText: 'Location not found. Try again!',
        redText: '',
        context: context,
      );
    }
  }

  void onInit(BuildContext context) async {
    await getHousesFromFirebase();
    if (HiveService.getUser().role != "anonymous") {
      await loadFavoriteHouses(HiveService.getUser().id!);
    }
    _generateMarkers(context);
  }

  void onMapCreated(GoogleMapController controller) async {
    completer.complete(controller);
    await _setMapStyle(await completer.future);
    // await animateCameraToUserCurrentPosition(await completer.future);
  }

  /// * -- Camera control
  Future<void> animateCameraToUserCurrentPosition(
    GoogleMapController mapController, {
    double zoom = 14.2,
  }) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: await _getUserCurrentPosition(),
          zoom: zoom,
        ),
      ),
    );
  }

  Future<LatLng> _getUserCurrentPosition() async {
    final position = await Permissions.getGeoLocationPosition();
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> _setMapStyle(GoogleMapController mapController) async {
    String mapStyle =
        await rootBundle.loadString('assets/map_style/picco_map.json');
    mapController.setMapStyle(mapStyle);
  }

  CameraPosition initialCamPosition() {
    final position = getCityInPosition(
      textEditingController.text.trim().toString(),
    );

    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 12.8,
    );
  }

  void zoomIn() async {
    final mapController = await completer.future;
    mapController.animateCamera(CameraUpdate.zoomIn());
    notifyListeners();
  }

  void zoomOut() async {
    final mapController = await completer.future;
    mapController.animateCamera(CameraUpdate.zoomOut());
    notifyListeners();
  }

  Future<void> searchCameraMove({
    double zoom = 14.2,
  }) async {
    final mapController = await completer.future;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: const LatLng(1, 1),
          zoom: zoom,
        ),
      ),
    );
  }

  /// * -- Camera control

  /// * -- Marker control
  void _generateMarkers(BuildContext context) {
    MarkerGenerator(_markerWidgetsNotTapped(), (bitmaps) {
      markers = _mapBitmapsToMarkers(bitmaps);
      markersWhiteNotTapped.addAll(markers);

      notifyListeners();
    }).generate(context);

    MarkerGenerator(_markerWidgetsTapped(), (bitmaps) {
      markersBlackTapped = _mapBitmapsToMarkers(bitmaps);
    }).generate(context);
  }

  List<Widget> _markerWidgetsTapped() {
    return filteredHomes.isNotEmpty
        ? filteredHomes.values
            .map((home) => MarkerTemplateWidget(
                  name: home.price,
                  tapped: true,
                ))
            .toList()
        : homes
            .map((home) => MarkerTemplateWidget(
                  name: home.price,
                  tapped: true,
                ))
            .toList();
  }

  List<Widget> _markerWidgetsNotTapped() {
    return filteredHomes.isNotEmpty
        ? filteredHomes.values
            .map((home) => MarkerTemplateWidget(
                  name: home.price,
                  tapped: false,
                ))
            .toList()
        : homes
            .map((home) => MarkerTemplateWidget(
                  name: home.price,
                  tapped: false,
                ))
            .toList();
  }

  Set<Marker> _mapBitmapsToMarkers(List<Uint8List> bitmaps) {
    Set<Marker> markersList = {};

    for (int i = 0; i < bitmaps.length; i++) {
      final home =
          filteredHomes.isNotEmpty ? filteredHomes.values.toList()[i] : homes[i];
      final bitmap = bitmaps[i];

      final marker = Marker(
        markerId: MarkerId(home.id!),
        position: LatLng(home.geo.latitude, home.geo.longitude),
        icon: BitmapDescriptor.fromBytes(bitmap),
        onTap: () async {
          updateUIMarkers(home);
          bottomHouseWidgetUpdate(home);
        },
      );

      markersList.add(marker);
    }
    return markersList;
  }

  void updateUIMarkers(HomeModel home) {
    markers
      ..clear()
      ..addAll(
        {
          markersBlackTapped.firstWhere(
            (element) => home.id.toString() == element.markerId.value,
          ),
          ...markersWhiteNotTapped.where(
            (element) => home.id.toString() != element.markerId.value,
          ),
        },
      );
  }

  void bottomHouseWidgetUpdate(HomeModel home) async {
    final mapController = await completer.future;

    bottomHomeElement = HomeSnackBarElement(
      mapController: mapController,
      homeModel: homes.firstWhere(
        (element) => home.id == element.id,
      ),
    );
    notifyListeners();
  }

  void bottomHouseWidgetClear() {
    markers
      ..clear()
      ..addAll(markersWhiteNotTapped);

    bottomHomeElement = const SizedBox.shrink();
    notifyListeners();
  }
}
