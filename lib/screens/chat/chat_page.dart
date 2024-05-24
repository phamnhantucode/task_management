import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:room_master_app/common/extensions/extensions.dart';
import 'package:room_master_app/domain/service/cloud_storage_service.dart';
import 'package:room_master_app/domain/service/file_picker_service.dart';
import 'package:room_master_app/models/enum/image_picker_type.dart';
import 'package:room_master_app/screens/component/bottomsheet/upload_attachment_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.room});

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  void _handleOnSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(message, widget.room.id);
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => UploadAttachmentPage(
        onImageSelection: () {
          _handleImageSelection();
          context.pop();
        },
        onFileSelection: () {
          _handleFileSelection();
          context.pop();
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }

  void _handleImageSelection() async {
    final imagePath =
        await FileService.instance.imageSelection(ImagePickerType.gallery);
    if (imagePath != null) {
      _setAttachmentUploading(true);
      final downloadPath =
          await CloudStorageService.instance.uploadImage(imagePath);
      if (downloadPath != null) {
        final message = types.PartialImage(
          name: path.basename(imagePath),
          size: File(imagePath).lengthSync(),
          uri: downloadPath,
        );
        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleFileSelection() async {
    final filePath = await FileService.instance.fileSelection(FileType.any);
    if (filePath != null) {
      _setAttachmentUploading(true);
      final downloadPath =
          await CloudStorageService.instance.uploadFile(filePath);
      if (downloadPath != null) {
        final message = types.PartialFile(
          name: path.basename(filePath),
          size: File(filePath).lengthSync(),
          uri: downloadPath,
        );
        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentDir/${message.name}';

          if (!File(localPath).existsSync()) {
            await File(localPath).writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }

        OpenFilex.open(localPath);
      }
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  @override
  Widget build(BuildContext context) {
    final partner = widget.room.users.firstWhere(
      (user) => user.id != FirebaseChatCore.instance.firebaseUser?.uid,
    );
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(partner.imageUrl ?? ''),
              ),
              const SizedBox(width: 8),
              Text(partner.firstName ?? '', style: context.textTheme.labelMedium),
            ])
        ),
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return Chat(
                theme: const DefaultChatTheme(
                    primaryColor: Colors.lightBlueAccent),
                inputOptions: const InputOptions(
                  sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                ),
                messages: snapshot.data ?? [],
                isAttachmentUploading: _isAttachmentUploading,
                onSendPressed: _handleOnSendPressed,
                onAttachmentPressed: _handleAttachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                user: types.User(
                    id: FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
              );
            },
          ),
        ));
  }
}
