import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/screens/chat/chat_page.dart';
import 'package:room_master_app/screens/chat/users_page.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializedFlutterFire();
    super.initState();
  }

  void initializedFlutterFire() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() {
    context.read<AuthenticationCubit>().logout();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (element) => element.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        //
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(right: 16),
        child: CircleAvatar(
            backgroundColor: hasImage ? Colors.transparent : color,
            backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
            radius: 20,
            child: !hasImage
                ? Text(
                    name.isEmpty ? '' : name[0].toUpperCase(),
                    style: context.textTheme.labelSmall
                        ?.copyWith(color: context.appColors.textWhite),
                  )
                : null));
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _user == null
                ? null
                : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const UsersPage(),
                ),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Rooms'),
      ),
      body: _user == null
          ? const SizedBox.shrink()
          : StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No rooms'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        room: room,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    TFSearch(context),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          _buildAvatar(room),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(room.name ?? '',
                                  style: context.textTheme.labelSmall
                                      ?.copyWith(
                                      color:
                                      context.appColors.textBlack)),
                              const SizedBox(
                                height: 2,
                              ),
                              Text("Hi ban! Cho minh muon 100k",
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(
                                      color: context
                                          .appColors.colorDarkGray))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

}
