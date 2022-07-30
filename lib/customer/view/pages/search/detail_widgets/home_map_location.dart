import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picco/customer/view/pages/search/detail_page.dart';
import 'package:picco/models/home_model.dart';
import 'package:provider/provider.dart';

class DetailMapView extends StatelessWidget {
  const DetailMapView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final geo = ModalRoute.of(context)?.settings.arguments as Geo;
    return ChangeNotifierProvider(
      create: (context) => DetailPageModel(),
      builder: (context, child) {
        final provider = context.watch<DetailPageModel>();
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: (mapController) {},
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    geo.latitude,
                    geo.longitude,
                  ),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('house_geo'),
                    position: LatLng(
                      geo.latitude,
                      geo.longitude,
                    ),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                },
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
        );
      },
    );
  }
}
