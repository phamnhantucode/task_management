import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/blocs/setting/setting_cubit.dart';
import 'package:room_master_app/common/app_setting.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/models/enum/image_picker_type.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';

import '../../common/assets/app_assets.dart';
import '../component/rm_switch.dart';
import 'bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ProfileBloc()
        ..add(InitBloc(user: context.read<AuthenticationCubit>().state.user)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.text_profile),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16.0),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 156,
                        height: 156,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        // Add padding around the avatar
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              if (state.avatarPath != null) {
                                return ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: state.avatarPath!,
                                      fit: BoxFit.cover,
                                    ));
                              } else {
                                return ClipOval(
                                  child: Image.network(
                                    'https://example.com/avatar.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.blue.shade100)),
                          color: Colors.blue,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 22,
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              barrierColor: Colors.grey.shade400.withAlpha(25),
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext innerContext) {
                                return BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: const EditAvatarPage(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                  BlocBuilder<AuthenticationCubit, AuthenticationState>(
                    builder: (context, state) {
                      if (state.user != null) {
                        return Text(
                          state.user!.displayName != null && state.user!.displayName!.isNotEmpty
                              ? state.user!.displayName!
                              : state.user!.email!,
                          style: context.textTheme.labelMedium,
                          textAlign: TextAlign.center,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: context.appColors.buttonEnable,
                        borderRadius: const BorderRadiusDirectional.all(
                            Radius.circular(8))),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      title: Center(
                          child: Text(
                            context.l10n.text_edit_profile,
                            style: context.textTheme.labelMedium?.copyWith(
                                color: context.appColors.textOnBtnEnable),
                          )),
                      onTap: () async {
                        await context.push(NavigationPath.editProfile);
                        context.read<AuthenticationCubit>().reloadUser();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    leading: const Icon(
                      Icons.lock,
                      color: Colors.lightGreen,
                    ),
                    title: Text(context.l10n.text_change_password),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      context.push(NavigationPath.changePassword);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ),
                    title: Text(context.l10n.text_settings),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext innerContext) {
                          return BlocProvider.value(
                              value: context.read<ProfileBloc>(),
                              child: const SettingPage());
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.orange,
                    ),
                    title: Text(context.l10n.text_notifications),
                    trailing: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return RMSwitch(
                          value: state.isTurnOnNotification,
                          onChanged: (value) {
                            context.read<ProfileBloc>().add(
                                SetNotification(isTurnOnNotification: value));
                          },
                        );
                      },
                    ),
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    title: Text(context.l10n.text_logout),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      context.read<AuthenticationCubit>().logout();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EditAvatarPage extends StatelessWidget {
  const EditAvatarPage({
    super.key,
  });

  Future<String?> imageSelector(BuildContext context,
      ImagePickerType pickerType) async {
    XFile? imageFile;
    final imagePicker = ImagePicker();
    switch (pickerType) {
      case ImagePickerType.gallery:
        imageFile = await imagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 90);
        break;
      case ImagePickerType.camera:
        imageFile = await imagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile.path);
    } else {
      print("You have not taken image");
    }
    return imageFile?.path;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisSize: MainAxisSize.min,
          children: [
            TMElevatedButton(
              onPressed: () {
                context.pop();
              },
              label: context.l10n.text_dismiss,
              textColor: Colors.red,
              height: 52,
              color: context.appColors.defaultBgContainer,
            ),
            const SizedBox(
              height: 24,
            ),
            TMElevatedButton(
              onPressed: () async {
                final filePath =
                await imageSelector(context, ImagePickerType.gallery);
                if (filePath != null) {
                  context
                      .read<ProfileBloc>()
                      .add(SetAvatarPath(avatarPath: filePath));
                  context.pop();
                }
              },
              label: context.l10n.text_select_photo_from_device,
              textColor: context.appColors.textBlack,
              height: 60,
              color: context.appColors.defaultBgContainer,
            ),
            TMElevatedButton(
              onPressed: () async {
                final filePath =
                await imageSelector(context, ImagePickerType.camera);
                if (filePath != null) {
                  context
                      .read<ProfileBloc>()
                      .add(SetAvatarPath(avatarPath: filePath));
                  context.pop();
                }
              },
              label: context.l10n.text_new_photo_shoot,
              textColor: context.appColors.textBlack,
              height: 60,
              color: context.appColors.defaultBgContainer,
            ),
            TMElevatedButton(
              onPressed: () {},
              label: context.l10n.text_show_profile_picture,
              textColor: context.appColors.textBlack,
              height: 60,
              color: context.appColors.defaultBgContainer,
            ),
            TMElevatedButton(
              onPressed: () {},
              label: context.l10n.text_choose_an_existing_avatar,
              textColor: context.appColors.textBlack,
              height: 60,
              color: context.appColors.defaultBgContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                context.l10n.text_settings,
                style: context.textTheme.labelLarge,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.text_theme,
                  style: context.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<SettingCubit, SettingState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        for (var i = 0; i < ThemeMode.values.length; i++)
                          buildItemRadio<ThemeMode>(
                            context,
                            value: ThemeMode.values[i],
                            groupValue: state.themeSelected,
                            label: ThemeMode.values[i]
                                .getLocalizationText(context),
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<SettingCubit>()
                                    .setThemeMode(value);
                              }
                            },
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.text_language,
                  style: context.textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: context.appColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    leading: SvgPicture.asset(AppAssets.iconEnglishFlag),
                    title: Text(context
                        .watch<SettingCubit>()
                        .state
                        .languageSelected
                        .getLocalizationText(context)),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext innerContext) {
                          return BlocProvider.value(
                            value: context.read<SettingCubit>(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocBuilder<SettingCubit, SettingState>(
                                builder: (context, state) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var i = 0;
                                      i < Language.values.length;
                                      i++)
                                        ListTile(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 12),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          leading: SvgPicture.asset(Language
                                              .values[i]
                                              .getAssetPathIconLanguage()),
                                          title: Text(Language.values[i]
                                              .getLocalizationText(context)),
                                          trailing: Checkbox(
                                            value: state.languageSelected ==
                                                Language.values[i],
                                            onChanged: (value) {
                                              context
                                                  .read<SettingCubit>()
                                                  .setLanguage(
                                                  Language.values[i]);
                                            },
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded buildItemRadio<T>(BuildContext context, {
    required T value,
    required T groupValue,
    void Function(T? value)? onChanged,
    required String label,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: () => onChanged != null ? onChanged(value) : null,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: context.appColors.borderColor)),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Radio(
                      fillColor: MaterialStatePropertyAll(
                          context.appColors.buttonEnable),
                      value: value,
                      groupValue: groupValue,
                      onChanged: onChanged,
                    ),
                  ),
                  Text(label),
                ],
              )),
        ),
      ),
    );
  }
}