import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:room_master_app/common/assets/app_assets.dart';
import 'package:room_master_app/l10n/l10n.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, this.object, this.height = 450});

  final String? object;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.iconEmpty,
            width: height / 4,
            height: height / 4,
          ),
          const SizedBox(height: 16),
          Text(
              object == null
                  ? 'No data found'
                  : context.l10n.text_you_currently_have_no_something(object!),
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class EmptyPage2 extends StatelessWidget {
  const EmptyPage2({super.key, this.object, this.height = 450});

  final String? object;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.iconDinosaur,
            width: height / 4,
            height: height / 4,
          ),
          const SizedBox(height: 8),
          Text(
              object == null
                  ? 'No data found'
                  : context.l10n.text_you_currently_have_no_something(object!),
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

