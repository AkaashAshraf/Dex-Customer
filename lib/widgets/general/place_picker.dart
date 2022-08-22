import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Place extends StatefulWidget {
  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  var initialPosition = LatLng(-33.8567844, 151.213108);
  PickResult selectedPlace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Icon(
          Icons.edit_location,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ContainerResponsive(
            child: PlacePicker(
              initialPosition: initialPosition,
              apiKey: 'AIzaSyD24UJE5__LvBFf6IvrYfVz7Lof9vy8jJw',
              hintText: 'enterLocation'.tr(),
              automaticallyImplyAppBarLeading: false,
              useCurrentLocation: true,
              selectInitialPosition: true,
              enableMapTypeButton: false,
              pinBuilder: (context, state) {
                if (state == PinState.Idle) {
                  return Image(
                    image: AssetImage('images/shopmarker.png'),
                    width: 40,
                    height: 40,
                  );
                } else {
                  return Image(
                    image: AssetImage('images/shopmarker.png'),
                    width: 50,
                    height: 50,
                  );
                }
              },
              selectedPlaceWidgetBuilder:
                  (context, selectedPlac, state, isSearching) {
                return isSearching
                    ? Container()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            var pref = await SharedPreferences.getInstance();
                            pref.setBool('locSelected', true);
                            pref.setDouble(
                                'lat', selectedPlac.geometry.location.lat);
                            pref.setDouble(
                                'long', selectedPlac.geometry.location.lng);
                            setState(() {
                              selectedPlace = selectedPlac;
                            });
                            Navigator.of(context).pop(selectedPlace);
                          },
                          child: ContainerResponsive(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 550,
                              height: 80,
                              margin: EdgeInsetsResponsive.only(
                                left: 20,
                                right: 20,
                                bottom: 30,
                              ),
                              child: Center(
                                child: TextResponsive('ConfirmLocation'.tr(),
                                    style: TextStyle(
                                        fontSize: 27, color: Colors.white)),
                              )),
                        ),
                      );
              },
            ),
          ),
          Positioned(
            bottom: 80,
            child: selectedPlace == null
                ? Container()
                : ContainerResponsive(
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 40),
                    height: 80,
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Color(0xffED8437), size: 25),
                        SizedBoxResponsive(width: 20),
                        TextResponsive(selectedPlace.formattedAddress ?? "",
                            style: TextStyle(
                              fontSize: 25,
                            )),
                      ],
                    )),
          ),
        ],
      ),
    );
  }
}
