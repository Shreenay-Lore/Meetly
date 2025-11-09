import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetly/core/utils/google_map_utils.dart';
import 'package:meetly/features/create_meet/presentation/page/create_meet_page.dart';
import 'package:meetly/features/main/presentation/bloc/main_bloc.dart';
import 'package:meetly/features/main/presentation/bloc/main_event.dart';
import 'package:meetly/features/main/presentation/bloc/main_state.dart';
import 'package:meetly/features/main/presentation/widgets/main_bottom_sheet.dart';
import 'package:meetly/features/meet/domain/entity/meet_entity.dart';
import 'package:meetly/features/meet/presentation/page/meet_page.dart';
import 'package:meetly/features/profile/presentation/page/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String route = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const double baseRadius = 120000;
  GoogleMapController? mapController;
  Set<Marker> mapMarkers = {};

  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(GetUserLocationEvent());
    context.read<MainBloc>().add(GetCurrentMeetsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state.mapStatus == MainStatus.successfullyGotUserLocation &&
            state.userLocation != null) {
          mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(state.userLocation!, 15));
          context.read<MainBloc>().add(GetNearbyMeetsEvent());
        }
        if (state.mapStatus == MainStatus.success &&
            (state.mapMeets?.isNotEmpty ?? false)) {
          updateMarkers(state.mapMeets!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(40, 40)),
                onMapCreated: (controller) {
                  mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: mapMarkers,
                onCameraIdle: () {
                  if (mapController == null) return;

                  mapController!.getVisibleRegion().then((bounds) async {
                    final center = LatLng(
                        (bounds.northeast.latitude +
                                bounds.southwest.latitude) /
                            2,
                        (bounds.northeast.longitude +
                                bounds.southwest.longitude) /
                            2);
                    final radius =
                        _calculateRadius(await mapController!.getZoomLevel());

                    context
                        .read<MainBloc>()
                        .add(GetMapMeetsEvent(center: center, radius: radius));
                  });
                },
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildFloatingButton(
                        context,
                        icon: Icons.add_rounded,
                        onPressed: () => context.push(CreateMeetPage.route),
                        isPrimary: true,
                      ),
                      const SizedBox(width: 12),
                      _buildFloatingButton(
                        context,
                        icon: Icons.person_rounded,
                        onPressed: () => context.push(ProfilePage.route),
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ),
              const MainBottomSheet()
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isPrimary 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                : Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: isPrimary
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Icon(
              icon,
              size: 26,
              color: isPrimary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  double _calculateRadius(double zoom) {
    return baseRadius / (zoom / 5);
  }

  Future updateMarkers(List<MeetEntity> meets) async {
    Set<Marker> newMarkers = {};

    for (var value in meets) {
      final BitmapDescriptor icon = await GoogleMapUtils.getMarkerIcon(value.admin.avatar);
      newMarkers.add(
        Marker(
          markerId: MarkerId(value.id),
          icon: icon,
          position: LatLng(value.latitude!, value.longitude!),
          onTap: (){
            context.push(MeetPage.route(value.id));
          }
        ),
      );
      setState(() {
        mapMarkers = newMarkers;
      });
    }
  }

  
}
