import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_management_module/data/lists.dart';
import 'package:user_management_module/strings.dart';
import 'package:user_management_module/ui/home_page.dart';

import '../business_logic/news/news_cubit.dart';

///Globe page- Displays news of selected country

class LocationNewsPage extends StatefulWidget {
  const LocationNewsPage({Key? key}) : super(key: key);

  @override
  State<LocationNewsPage> createState() => _LocationNewsPageState();
}

class _LocationNewsPageState extends State<LocationNewsPage> {

  late GoogleMapController googleMapController;

  Position? lastKnownPosition;

  late CameraPosition lastPosition = CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 4.5);
  CameraPosition? savePosition;

  final Map<String, Marker> _markers = {};

  getLastKnown() async{
    lastKnownPosition = await Geolocator.getLastKnownPosition();
    lastPosition = CameraPosition(target: LatLng(lastKnownPosition?.latitude?? 20.5937, lastKnownPosition?.longitude?? 78.9629), zoom: 4.5);
    setState(() {
      print(lastPosition);
    });
  }

  @override
  void initState() {
    getLastKnown();
    super.initState();
  }

  onMapCreated(GoogleMapController controller){
    googleMapController = controller;
    _markers.clear();
    setState(() {
      for(int i = 0; i < countriesList.length; i++){
        final marker = Marker(
          markerId: MarkerId(countriesList[i]['id']),
          position: LatLng(countriesList[i]['latitude'], countriesList[i]['longitude']),
          infoWindow: InfoWindow(
            title: countriesList[i]['name'],
            //snippet: countriesList[i]['name'],
            onTap: () {
              print(countriesList[i]['name']);
            }
          ),
          onTap: (){
            print("Latitude : ${countriesList[i]['latitude']} Longitude : ${countriesList[i]['longitude']}");

            BlocProvider.of<NewsCubit>(context).refreshNews(countryCode: countriesList[i]['code'],);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (BuildContext context) => HomePage()));

            HomePageState.selectedIndex = 0;
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => HomePage()));
            print("Setting state");
            // setState(() {
            //   print("In State");
            //
            // });

            //Get.toNamed('/home');
           },
        );
        _markers[countriesList[i]['name']] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(initialCameraPosition: lastPosition, mapType: MapType.normal, zoomControlsEnabled: false, mapToolbarEnabled: false,
          onMapCreated: onMapCreated,
          markers: _markers.values.toSet(),
        ),

        Positioned(
          bottom: 20,
          right: 10,
          child: FloatingActionButton(
            onPressed: () async{
              Position position = await getCurrentLocation();

              googleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 4.5)));

              //_markers.clear();
             //_markers.add(Marker(markerId: const MarkerId('currentLocation'), position: LatLng(position.latitude, position.longitude)));

              setState(() {});
            },
            tooltip: Strings.currLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  Future<Position> getCurrentLocation() async{
    bool serviceEnable;
    LocationPermission locationPermission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    
    if(!serviceEnable){
      Get.defaultDialog(title: 'Current Location',
        content: const Text('To continue turn on the location'));
      return Future.error('Location service disabled');
    }

    locationPermission = await Geolocator.checkPermission();

    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();

      if(locationPermission == LocationPermission.denied){
        return Future.error('Location permission denied');
      }
    }

    if(locationPermission == LocationPermission.deniedForever){
      return Future.error('Location permission permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  // Future<void> goToTarget() async{
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  // }
}
