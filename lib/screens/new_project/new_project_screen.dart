import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/SpacerComponent.dart';
import 'package:room_master_app/screens/new_project/bloc/new_project_bloc.dart';

import '../component/tm_elevated_button.dart';
import '../component/tm_text_field.dart';

class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewProjectBloc(),
      child: BlocListener<NewProjectBloc, NewProjectState>(
        listener: (context, state) {
          if (state.status == NewProjectStatus.success) {
            Navigator.pop(context);
          } else {
            if (state.status == NewProjectStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.text_error_create_project),
                ),
              );
            }
          }
          context.read<NewProjectBloc>().add(const CleanNewProject());
        },
        child: Builder(builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.mediaQuery.viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpacerComponent.l(
                      isVertical: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.l10n.text_create_project,
                              style: context.textTheme.labelLarge,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, top: 16, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildProjectNameSection(context),
                          SpacerComponent.m(
                            isVertical: true,
                          ),
                          _buildDescriptionSection(context),
                          SpacerComponent.m(
                            isVertical: true,
                          ),
                          _buildConfirmBtn(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProjectNameSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TMTextField(
          hintText: context.l10n.text_enter_project_name,
          textStyle: context.textTheme.bodyMedium,
          onTextChange: (e) {
            context.read<NewProjectBloc>().add(NewProjectNameChanged(e));
          },
          borderColor: context.appColors.borderColor,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.text_description,
          style: context.textTheme.labelMedium,
        ),
        SizedBox(
          height: 8.h,
        ),
        TMTextField(
          hintText: context.l10n.text_description,
          textStyle: context.textTheme.bodyMedium,
          maxLines: 3,
          onTextChange: (e) {
            context.read<NewProjectBloc>().add(NewProjectDescriptionChanged(e));
          },
          borderColor: context.appColors.borderColor,
        ),
      ],
    );
  }

  Widget _buildConfirmBtn(BuildContext context) {
    return TMElevatedButton(
      height: 50,
      label: context.l10n.text_confirm,
      borderRadius: 16,
      style: context.textTheme.labelLarge
          ?.copyWith(color: context.appColors.textWhite),
      color: context.appColors.buttonEnable,
      onPressed: () {
        context.read<NewProjectBloc>().add(const NewProjectConfirm());
      },
    );
  }
}
