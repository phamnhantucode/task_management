import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

class UploadAttachmentPage extends StatelessWidget {
  const UploadAttachmentPage(
      {super.key,
      this.onImageSelection,
      this.onFileSelection,
      required this.onCancel});

  final void Function()? onImageSelection;
  final void Function()? onFileSelection;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildButtons(context),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload),
          const SizedBox(
            width: 8,
          ),
          Text(context.l10n.text_attachment,
              style: context.textTheme.labelLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          onImageSelection == null
              ? const SizedBox.shrink()
              : Expanded(
                  child: _buildButton(context, onImageSelection, Icons.image,
                      context.l10n.text_photo)),
          SizedBox(
            width: onImageSelection == null || onFileSelection == null ? 8 : 0,
          ),
          onFileSelection == null
              ? const SizedBox.shrink()
              : Expanded(
                  child: _buildButton(context, onFileSelection,
                      Icons.attach_file, context.l10n.text_file)),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, void Function()? onPressed,
      IconData icon, String text) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black.withOpacity(0.7)),
          color: context.appColors.defaultBgContainer,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 2)
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: context.appColors.textBlack),
            const SizedBox(width: 8),
            Text(text, style: context.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onCancel,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.7)),
            color: context.appColors.defaultBgContainer,
            boxShadow: [
              BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.7),
                  offset: const Offset(0, 2),
                  blurRadius: 2)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: Text(context.l10n.text_cancel,
                style: context.textTheme.labelMedium
                    ?.copyWith(color: Colors.blueAccent)),
          ),
        ),
      ),
    );
  }
}
