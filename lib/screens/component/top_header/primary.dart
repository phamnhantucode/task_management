import 'package:flutter/material.dart';

class TopHeader extends StatefulWidget {
  const TopHeader(
      {super.key, required this.title, this.leftAction, this.rightAction});
  final String title;
  final Function? leftAction;
  final Function? rightAction;
  @override
  State<StatefulWidget> createState() => TopHeaderState();
}

class TopHeaderState extends State<TopHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.leftAction != null)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300]),
            child: Center(
              child: widget.leftAction != null
                  ? GestureDetector(
                      onTap: () => {widget.leftAction!()},
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        size: 32,
                      ),
                    )
                  : const SizedBox(width: 1),
            ),
          ),
        const Expanded(
            child: Text(
          'Home screen',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        )),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.grey[300]),
          child: Center(
            child: widget.rightAction != null
                ? GestureDetector(
                    onTap: () => {widget.rightAction!()},
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      size: 32,
                    ),
                  )
                : const SizedBox(width: 1),
          ),
        ),
      ],
    );
  }
}
