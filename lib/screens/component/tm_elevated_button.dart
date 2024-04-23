import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_master_app/common/extensions/context.dart';

import '../../blocs/loading_button/loading_button_cubit.dart';

class TMElevatedButton extends StatelessWidget {
  const TMElevatedButton({super.key,this.height, this.color, this.label, this.borderRadius, this.style, this.onPressed});
  final double? height;
  final Color? color;
  final String? label;
  final double? borderRadius;
  final TextStyle? style;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingButtonCubit, bool>(
  builder: (context, state) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(color),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius!))),
        ),
        onPressed:  onPressed,
        child: state?  CircularProgressIndicator(color: context.appColors.buttonEnable,) : Text(label!, style: style,)
      ),
    );
  },
);
  }
}



