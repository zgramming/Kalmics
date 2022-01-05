import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/fonts.dart';
import 'modal_bottomsheet_header_indicator.dart';

class MBSStorageDeniedPermanent extends StatelessWidget {
  const MBSStorageDeniedPermanent({
    Key? key,
    this.message = '',
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ModalBottomSheetHeaderIndicator(),
          Center(
            child: Text(
              message,
              style: amiko.copyWith(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                await openAppSettings();
              } catch (e) {
                log('error cant open app setting ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }
}
