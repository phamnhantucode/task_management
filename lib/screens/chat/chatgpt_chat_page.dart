import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/extensions.dart';
import 'package:room_master_app/main.dart';

import '../../common/assets/app_assets.dart';

class ChatGPTChatPage extends StatefulWidget {
  const ChatGPTChatPage({super.key});

  @override
  State<ChatGPTChatPage> createState() => _ChatGPTChatPageState();
}

class _ChatGPTChatPageState extends State<ChatGPTChatPage> {
  List<types.Message> messages = [];
  List<Content> contents = [];
  final gemini = Gemini.instance;

  @override
  void initState() {
    // contents.add(Content(
    //   parts: [
    //     Parts(
    //       text: 'I will give you this format example: '
    //           'project: "Project Name", '
    //           'task: "Task Name", '
    //           'insufficientDescription: "Description of the task", '
    //           'And your response should be the description of the task. It is the text of the task description.'
    //           'For example, if the insufficientDescription of task is "ouline red", the response should be "Button with red outline".',
    //     )
    //   ],
    //   role: 'user',
    // ));
    super.initState();
  }

  void _handleOnSendPressed(types.PartialText message) async {
    setState(() {
      messages.add(types.TextMessage(
          author: types.User(
              id: context.read<AuthenticationCubit>().state.user?.uid ?? ''),
          id: uuid.v1(),
          text: message.text));
    });
    contents.add(Content(
      parts: [
        Parts(
          text: message.text,
        )
      ],
      role: 'user',
    ));

    final result = await gemini.chat(contents);

    var text = result?.output ?? 'No response from the server';

    setState(() {
      messages.add(types.TextMessage(
          author: const types.User(id: 'ChatGPT'), id: uuid.v1(), text: text));
      contents.add(Content(
        parts: [
          Parts(
            text: text,
          )
        ],
        role: 'model',
      ));
    });
  }

  // void _setAttachmentUploading(bool uploading) {
  //   setState(() {
  //     _isAttachmentUploading = uploading;
  //   });
  // }
  //
  // void _handleAttachmentPressed() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) => UploadAttachmentPage(
  //       onImageSelection: () {
  //         _handleImageSelection();
  //         context.pop();
  //       },
  //       onFileSelection: () {
  //         _handleFileSelection();
  //         context.pop();
  //       },
  //       onCancel: () {
  //         context.pop();
  //       },
  //     ),
  //   );
  // }
  //
  // void _handleImageSelection() async {
  //   final imagePath =
  //   await FileService.instance.imageSelection(ImagePickerType.gallery);
  //   if (imagePath != null) {
  //     _setAttachmentUploading(true);
  //     final downloadPath =
  //     await CloudStorageService.instance.uploadImage(imagePath);
  //     if (downloadPath != null) {
  //       final message = types.PartialImage(
  //         name: path.basename(imagePath),
  //         size: File(imagePath).lengthSync(),
  //         uri: downloadPath,
  //       );
  //       FirebaseChatCore.instance.sendMessage(message, widget.room.id);
  //       _setAttachmentUploading(false);
  //     }
  //   }
  // }
  //
  // void _handleFileSelection() async {
  //   final filePath = await FileService.instance.fileSelection(FileType.any);
  //   if (filePath != null) {
  //     _setAttachmentUploading(true);
  //     final downloadPath =
  //     await CloudStorageService.instance.uploadFile(filePath);
  //     if (downloadPath != null) {
  //       final message = types.PartialFile(
  //         name: path.basename(filePath),
  //         size: File(filePath).lengthSync(),
  //         uri: downloadPath,
  //       );
  //       FirebaseChatCore.instance.sendMessage(message, widget.room.id);
  //       _setAttachmentUploading(false);
  //     }
  //   }
  // }

  // void _handleMessageTap(BuildContext context, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;
  //
  //     if (message.uri.startsWith('http')) {
  //       try {
  //         final updatedMessage = message.copyWith(isLoading: true);
  //         FirebaseChatCore.instance.updateMessage(
  //           updatedMessage,
  //           widget.room.id,
  //         );
  //
  //         final client = http.Client();
  //         final request = await client.get(Uri.parse(message.uri));
  //         final bytes = request.bodyBytes;
  //         final documentDir = (await getApplicationDocumentsDirectory()).path;
  //         localPath = '$documentDir/${message.name}';
  //
  //         if (!File(localPath).existsSync()) {
  //           await File(localPath).writeAsBytes(bytes);
  //         }
  //       } finally {
  //         final updatedMessage = message.copyWith(isLoading: false);
  //         FirebaseChatCore.instance.updateMessage(
  //           updatedMessage,
  //           widget.room.id,
  //         );
  //       }
  //
  //       OpenFilex.open(localPath);
  //     }
  //   }
  // }

  // void _handlePreviewDataFetched(
  //     types.TextMessage message,
  //     types.PreviewData previewData,
  //     ) {
  //   final updatedMessage = message.copyWith(previewData: previewData);
  //
  //   FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Row(children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: Image.asset(AppAssets.imageChatGptLogo).image,
              ),
              const SizedBox(width: 8),
              Text('ChatGPT', style: context.textTheme.labelMedium),
            ])),
        body: Chat(
          theme: const DefaultChatTheme(primaryColor: Colors.lightBlueAccent),
          inputOptions: const InputOptions(
            sendButtonVisibilityMode: SendButtonVisibilityMode.always,
          ),
          messages: messages.reversed.toList(),
          onSendPressed: _handleOnSendPressed,
          user:
              types.User(id: FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
        ));
  }
}
