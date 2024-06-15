import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

class TaskLeast extends StatelessWidget {
  final String title;
  final String status;
  final double value;
  final Color colorStatus;
   TaskLeast({super.key, required this.title, required this.status, required this.value, required this.colorStatus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.textWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: context.textTheme.titleSmall, overflow: TextOverflow.ellipsis, maxLines: 1)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorStatus,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: context.textTheme.bodyMedium?.copyWith(color:context.appColors.textWhite),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  context.l10n.progress,
                  style: const TextStyle(
                   fontSize: 14
                  ),
                ),
                Expanded(
                    child: Text("0%",
                      textAlign: TextAlign.end,
                      style: context.textTheme.bodySmall,
                    )
              )
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value:value,
              minHeight: 7,
              backgroundColor:
              Colors.grey.shade200,
              borderRadius:
              BorderRadius.circular(5),
            ),
            const SizedBox(height: 2),
            const SizedBox(height: 2),
             Row(
              children: [
                Icon(Icons.person, size: 15, color: Colors.grey),
                SizedBox(width: 4),
                Text('3 persons', style: context.textTheme.bodySmall?.copyWith(color: context.appColors.textGray)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
