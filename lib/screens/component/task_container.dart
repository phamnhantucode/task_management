import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room_master_app/common/extensions/context.dart';

class TaskContainer extends StatelessWidget {
  const TaskContainer({
    super.key,
    required this.context,
    required this.title,
    required this.content,
    this.backgroundColor,
    this.onTap,
    this.taskIcon,
    this.suffix,
    this.iconBackgroundColor,
    this.contentColor,
    this.isShadowContainer = true, this.onLongPress,
  });

  final BuildContext context;
  final bool isShadowContainer;
  final String title;
  final String content;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? contentColor;
  final Function? onTap;
  final Widget? taskIcon;
  final Widget? suffix;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (onTap != null) {
          onTap!();
        }
      },
      onLongPress: () {
        onLongPress?.call();
        HapticFeedback.vibrate();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 24, left: 4, right: 4),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          boxShadow: isShadowContainer
              ? [
                  BoxShadow(
                    color: context.appColors.borderColor,
                    spreadRadius: 1,
                    blurRadius: 2, // Moves shadow to the top
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor ?? context.appColors.defaultBgContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsetsDirectional.all(10),
                  child: Center(
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/128/11389/11389139.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.labelMedium,
                    ),
                    Text(
                      content.replaceAll('\n', ' '),
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: contentColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            suffix ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
