import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:room_master_app/common/extensions/context.dart';

Future<T?> showQrDialog<T>(BuildContext context, String title,
    String description, String qrData) {
  return showDialog<T?>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
              color: context.appColors.defaultBgContainer,
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: context.textTheme.labelMedium,
              ),
              Text(
                description,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: context.appColors.buttonEnable, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: QrImageView(
                  data: qrData,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}