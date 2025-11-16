import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetly/features/create_meet/presentation/widgets/form_section.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_bloc.dart';
import 'package:meetly/features/meet/presentation/bloc/meet_state.dart';

class MeetLocationSection extends StatelessWidget {
  const MeetLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, state) {
        if (state.status == MeetStatus.loading ||
            state.meetEntity?.longitude == null ||
            state.meetEntity?.latitude == null) {
          return SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSection(
              icon: CupertinoIcons.location_solid,
              label: 'Location',
              child: Container(
                height: 280,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            state.meetEntity!.latitude!,
                            state.meetEntity!.longitude!,
                          ),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('location'),
                            position: LatLng(
                              state.meetEntity!.latitude!,
                              state.meetEntity!.longitude!,
                            ),
                          )
                        },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        compassEnabled: false,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.map_pin_ellipse,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Meet Location',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
