import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

class UserDialog extends StatelessWidget {
  const UserDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 4, right: 4),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.appColors.borderColor,
            spreadRadius: 1,
            blurRadius: 2, // Moves shadow to the top
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: context.appColors.defaultBgContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsetsDirectional.all(10),
              child: Center(
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/128/11389/11389139.png",
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Text(
            'UserName',
            style: context.textTheme.labelMedium,
          )),
          PopupMenuButton<String>(
            onSelected: (String item) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: Text(
                  'Assign',
                  style: context.textTheme.bodySmall,
                ),
              ),
              PopupMenuItem<String>(
                child: Text(
                  'Remove',
                  style: context.textTheme.bodySmall,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
