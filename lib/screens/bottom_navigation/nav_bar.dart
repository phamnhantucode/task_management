import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/screens/bottom_navigation/bloc/bottom_nav_cubit.dart';

import '../../domain/repositories/friends/friends_repository.dart';
import '../../models/domain/friend/friend.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, NavFunction>(
      builder: (context, state) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: context.appColors.buttonEnable,
          elevation: 0.0,
          height: 60,
          child: Row(
            children: [
              navItem(
                Icons.home_outlined,
                state == NavFunction.home,
                onTap: () => context
                    .read<BottomNavCubit>()
                    .setNavItemSelected(NavFunction.home),
              ),
              navItem(
                Icons.calendar_month,
                state == NavFunction.calendar,
                onTap: () => context
                    .read<BottomNavCubit>()
                    .setNavItemSelected(NavFunction.calendar),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(
                child: StreamBuilder<List<Friend>>(
                    stream: FriendRepository.instance
                        .getListWaitedAcceptedStream(
                            FirebaseAuth.instance.currentUser?.uid ?? ''),
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: () => context
                              .read<BottomNavCubit>()
                              .setNavItemSelected(NavFunction.chat),
                          icon: badges.Badge(
                            badgeContent: const SizedBox(),
                            showBadge: snapshot.data?.isNotEmpty ?? false,
                            position:
                                badges.BadgePosition.topEnd(top: -2, end: -2),
                            child: Icon(
                              Icons.message_outlined,
                              color: state == NavFunction.chat
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              size: 26,
                            ),
                          ));
                    }),
              ),
              navItem(
                Icons.person_4_outlined,
                state == NavFunction.profile,
                onTap: () => context
                    .read<BottomNavCubit>()
                    .setNavItemSelected(NavFunction.profile),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: selected ? Colors.white : Colors.white.withOpacity(0.6),
            size: 26,
          )),
    );
  }
}
