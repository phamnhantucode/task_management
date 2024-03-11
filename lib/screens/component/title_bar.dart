import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/common/extensions/context.dart';

final class TMTitleBar extends StatelessWidget {
  const TMTitleBar({super.key, required this.title, this.prefix, this.suffix});

  final String title;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: 16.h),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: context.textTheme.bodyLarge
                    ?.copyWith(color: context.appColors.textBlack),
              ),
            ),
          ),
          suffix ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}