// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studify/utils/consts/app_colors.dart';

import 'flashcard_widgets/side_menu.dart';
import 'note_controller.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kBackgroundDark,
            kBackground,
            kBackgroundLight,
            kBackgroundLight2,
            kBackgroundLight3
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: GetBuilder<NotePageController>(
        init: Get.put(NotePageController()),
        initState: (_) {},
        builder: (_) {
          return Stack(children: [
            GetBuilder<NotePageController>(
              init: Get.find(),
              initState: (_) {},
              builder: (_) {
                return CustomScrollView(
                  controller: _.scrollController,
                  shrinkWrap: true,
                  slivers: [
                    ..._.slivers,
                    ...[SliverFillRemaining()],
                  ],
                );
              },
            ),
            GetBuilder<NotePageController>(
              init: Get.find(),
              initState: (_) {},
              builder: (_) {
                return FCMenu();
              },
            ),
          ]);
        },
      ),
    );
  }
}
