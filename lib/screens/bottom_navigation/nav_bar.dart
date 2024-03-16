import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/theme/app_colors.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: context.appColors.buttonEnable,
        elevation: 0.0,
          child: Row(
            children: [
              navItem(Icons.home_outlined, pageIndex == 0),
              navItem(Icons.calendar_month, pageIndex == 1),
              const SizedBox(
                width: 80,
              ),
              navItem(Icons.message_outlined, pageIndex == 2),
              navItem(Icons.person_4_outlined, pageIndex == 3),
            ],
          ),
        );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: selected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 32,
          )),
    );
  }
}
