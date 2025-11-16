import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetly/core/get_it/get_it.dart';
import 'package:meetly/core/ui/default_button.dart';
import 'package:meetly/core/ui/default_text_field.dart';
import 'package:meetly/features/create_meet/presentation/bloc/create_meet_bloc.dart';
import 'package:meetly/features/create_meet/presentation/bloc/create_meet_event.dart';
import 'package:meetly/features/create_meet/presentation/bloc/create_meet_state.dart';
import 'package:meetly/features/create_meet/presentation/widgets/form_section.dart';
import 'package:meetly/features/create_meet/presentation/page/location_picker_page.dart';
import 'package:meetly/features/meet/presentation/page/meet_page.dart';

class CreateMeetPage extends StatefulWidget {
  static const String route = '/create_meet';

  const CreateMeetPage({super.key});

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

class _CreateMeetPageState extends State<CreateMeetPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  GoogleMapController? _mapController;
  final ValueNotifier<TimeOfDay> _timeOfDay = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<LatLng?> _location = ValueNotifier(null);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeOfDay.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateMeetBloc>(),
      child: BlocConsumer<CreateMeetBloc, CreateMeetState>(
        listener: (context, state) {
          if (state.status == CreateMeetStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.errorMessage}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          if (state.status == CreateMeetStatus.success &&
              state.createdMeet != null) {
            context.pushReplacement(MeetPage.route(state.createdMeet!.id));
          }
        },
        builder: (context, state) {
          if (state.status == CreateMeetStatus.loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Create Meet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormSection(
                        icon: Icons.title_rounded,
                        label: 'Title',
                        child: DefaultTextField(
                          hintText: 'Enter meet title',
                          controller: _titleController,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FormSection(
                        icon: Icons.description_outlined,
                        label: 'Description',
                        child: DefaultTextField(
                          hintText: 'What\'s this meet about?',
                          controller: _descriptionController,
                          maxLength: 255,
                          minLines: 3,
                          maxLines: 6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FormSection(
                        icon: Icons.schedule_rounded,
                        label: 'Time',
                        subtitle: 'Auto-completes 2 hours after start',
                        child: _buildTimePicker(context),
                      ),
                      const SizedBox(height: 28),
                      FormSection(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        subtitle: 'Tap map to select location',
                        child: _buildLocationPicker(context),
                      ),
                      const SizedBox(height: 40),
                      ValueListenableBuilder<LatLng?>(
                        valueListenable: _location,
                        builder: (context, location, _) {
                          return ListenableBuilder(
                            listenable: Listenable.merge([
                              _titleController,
                              _descriptionController
                            ]),
                            builder: (context, _) {
                              final isEnabled = location != null &&
                                  _titleController.text.isNotEmpty &&
                                  _descriptionController.text.isNotEmpty;
                              return DefaultButton(
                                text: 'Create Meet',
                                onPressed: isEnabled
                                    ? () {
                                        context.read<CreateMeetBloc>().add(
                                              CreateMeetEvent(
                                                title: _titleController.text,
                                                description:
                                                    _descriptionController.text,
                                                time: _timeOfDay.value,
                                                location: location,
                                              ),
                                            );
                                      }
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return ValueListenableBuilder<TimeOfDay>(
      valueListenable: _timeOfDay,
      builder: (context, timeOfDay, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(

            children: [
              Text(
                'Meet auto-completes 2 hours after start',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 12),
                  
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   
                  _buildTimePart(context, timeOfDay.hour),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ':',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  _buildTimePart(context, timeOfDay.minute),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimePart(BuildContext context, int value) {
    return InkWell(
      onTap: () async {
        var time = await showTimePicker(
          context: context,
          initialTime: _timeOfDay.value,
          initialEntryMode: TimePickerEntryMode.inputOnly,
        );
        if (time != null) {
          _timeOfDay.value = time;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Text(
          value.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ),
    );
  }

  Widget _buildLocationPicker(BuildContext context) {
    return ValueListenableBuilder<LatLng?>(
      valueListenable: _location,
      builder: (context, location, _) {
        return InkWell(
          onTap: () async {
            LatLng? selectedLocation =
                await context.push(LocationPickerPage.route);
            if (selectedLocation != null) {
              _location.value = selectedLocation;
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(selectedLocation, 15),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 240,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: location != null
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                    : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: false,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: location != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selectedLocation'),
                            position: location,
                          )
                        }
                      : {},
                  initialCameraPosition: CameraPosition(
                    target: location ?? const LatLng(40.730610, -73.935242),
                    zoom: 15,
                  ),
                ),
                if (location == null)
                  Container(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_location_alt_outlined,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to select location',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}