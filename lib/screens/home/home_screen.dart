import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/home/bloc/test_bloc.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TestBloc(context.read())..add(OnInitial()),
          child: Builder(builder: (context) {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.text_display_some_text,
                  ),
                  onChanged: (value) => context
                      .read<TestBloc>()
                      .add(OnEditableFieldChange(newString: value)),
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<TestBloc>().add(OnSubmit());
                    },
                    child: const Text('Submit')),
                Expanded(
                  child: BlocBuilder<TestBloc, TestState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.test.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsetsDirectional.all(9.r),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade100,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 16.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.test[index].editableField,
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<TestBloc>().add(OnRemoveTest(test: state.test[index]));
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                    padding: EdgeInsetsDirectional.all(8.r),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
