import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetly/core/ui/default_button.dart';
import 'package:meetly/core/ui/default_text_field.dart';
import 'package:meetly/features/auth/presentation/bloc/user_bloc.dart';
import 'package:meetly/features/auth/presentation/bloc/user_event.dart';
import 'package:meetly/features/auth/presentation/bloc/user_state.dart';
import 'package:meetly/features/profile/presentation/widgets/circle_user_avatar.dart';

class EditProfilePage extends StatefulWidget {
  static const String route = '/edit_profile';

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _avatarFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var name = context.read<UserBloc>().state.userEntity?.name ?? '';
    var bio = context.read<UserBloc>().state.userEntity?.bio ?? '';
    _nameController.text = name;
    _bioController.text = bio;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                        onTap: () async {
                          try {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 1024,
                              maxHeight: 1024,
                              imageQuality: 85,
                            );
                            if (image != null) {
                              setState(() {
                                _avatarFile = File(image.path);
                              });
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error picking image: $e')),
                              );
                            }
                          }
                        },
                        child: _avatarFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _avatarFile!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleUserAvatar(
                                width: 100,
                                height: 100,
                                url: state.userEntity?.avatar,
                              )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    hintText: 'Enter your name',
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Bio',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DefaultTextField(
                    hintText: 'Enter bio',
                    controller: _bioController,
                    minLines: 2,
                    maxLines: 6,
                    maxLength: 255,
                  ),
                  Spacer(),
                  DefaultButton(
                    text: 'Save',
                    onPressed: (){
                      context.read<UserBloc>().add(EditProfileEvent(name: _nameController.text, bio: _bioController.text,avatar: _avatarFile));
                    },
                  )
                ],
              ),
            ),
          );
        },
        listener: (context,state){
          if(state.status==UserStatus.error){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
          }
          if(state.status == UserStatus.successfullyEditedProfile){
            context.pop();
          }
        },
      ),
    );
  }
}
