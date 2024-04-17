import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

class TopHeader extends StatefulWidget {
  const TopHeader(
      {super.key,
      required this.title,
      this.leftAction,
      this.rightAction,
      this.leftIcon,
      this.rightIcon});
  final String title;
  final void Function()? leftAction;
  final void Function()? rightAction;
  final IconData? leftIcon;
  final IconData? rightIcon;
  @override
  State<StatefulWidget> createState() => TopHeaderState();
}

class TopHeaderState extends State<TopHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.leftAction != null)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.appColors.bgGrayLight),
            child: Center(
              child: widget.leftAction != null
                  ? GestureDetector(
                      onTap: widget.leftAction,
                      child: Icon(
                        widget.leftIcon ?? Icons.arrow_back_outlined,
                        size: 26,
                        color: context.appColors.bgGray,
                      ),
                    )
                  : const SizedBox(width: 1),
            ),
          ),
        Expanded(
            child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        )),
        widget.rightAction != null
            ? Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.appColors.bgGrayLight),
                child: Center(
                    child: GestureDetector(
                  onTap: widget.rightAction,
                  child: Icon(
                    widget.rightIcon ?? Icons.notifications_none_outlined,
                    size: 26,
                    color: context.appColors.bgGray,
                  ),
                )),
              )
            : const SizedBox(width: 42),
      ],
    );
  }
}
