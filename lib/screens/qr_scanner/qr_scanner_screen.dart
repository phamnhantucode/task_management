import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/domain/repositories/project/project_repository.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/domain/service/qr_action.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/project_detail/request_join_project_page.dart';
import 'package:room_master_app/screens/qr_scanner/scanner_button_widgets.dart';
import 'package:room_master_app/screens/qr_scanner/scanner_error_widget.dart';

import '../profile/profile_other_user/profile_other_user_page.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
      useNewCameraSelector: true,
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 1000,
      formats: [BarcodeFormat.qrCode]);

  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      final value = barcodes.barcodes.firstOrNull;
      if (value != null && value.rawValue != null) {
        _subscription?.cancel();
        final pair = QrAction.decode(value.rawValue!);
        log(pair.first.toString());
        switch (pair.first) {
          case QrAction.profile:
            UsersRepository.instance.getUserById(pair.second).then((user) {
              if (user != null &&
                  context.read<AuthenticationCubit>().state.user?.uid !=
                      user.id) {
                context.pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => ProfileOtherUserPage(
                      otherUser: user,
                    ),
                  ),
                  (route) => true,
                );
              }
            });
          case QrAction.joinGroup:
          case QrAction.joinProject:
          log(pair.second.toString());

            ProjectRepository.instance.getProject(pair.second).then((project) {
              context.pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        RequestJoinProjectPage(project: project)),
                (route) => true,
              );
            });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.text_qr_scanner,
        ),
        actions: [
          ToggleFlashlightButton(controller: controller),
          SwitchCameraButton(controller: controller),
          AnalyzeImageFromGalleryButton(controller: controller),
        ],
      ),
      backgroundColor: context.appColors.defaultBgContainer,
      body: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: MobileScanner(
            overlayBuilder: (context, constraints) {
              return QRScannerOverlay(
                overlayColor: context.appColors.defaultBgContainer,
                borderColor: context.appColors.buttonEnable,
              );
            },
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}
