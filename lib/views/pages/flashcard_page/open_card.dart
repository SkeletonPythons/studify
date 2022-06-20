import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studify/consts/app_colors.dart';

import '../../../utils/sample_cards.dart';

class OpenFC extends StatelessWidget {
  OpenFC({
    required this.index,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final int index;
  final VoidCallback onTap;
  late final OpenCardController _ =
      Get.put<OpenCardController>(OpenCardController(index));
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverSafeArea(
          sliver: SliverAppBar(
            floating: true,
            elevation: 6,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: kAccent),
              onPressed: () => onTap(),
            ),
            backgroundColor: kBackgroundLight2,
            actions: [
              IconButton(
                icon: Icon(
                    _.isFav.value ? Icons.favorite : Icons.favorite_border,
                    color: _.isFav.value ? Colors.redAccent : Colors.grey),
                onPressed: () => _.toggleFav(),
              ),
              IconButton(
                  onPressed: () => _.toggleFields(),
                  icon: Icon(Icons.swap_horiz)),
            ],
            expandedHeight: Get.height * .1,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'title',
                style: GoogleFonts.ubuntuMono(
                  fontSize: Get.height * .05,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              'Front of Card:',
              style: GoogleFonts.neucha(
                fontSize: 20,
                color: kAccent,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(
            color: kAccent,
            thickness: 0.5,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverToBoxAdapter(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Get.height * .3,
              maxHeight: Get.height,
              minWidth: Get.width,
              maxWidth: Get.width,
            ),
            child: SizedBox.shrink(
              child: TextField(
                controller: _.frontController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                autocorrect: true,
                expands: true,
                maxLines: null,
                minLines: null,
                enableInteractiveSelection: true,
                enabled: _.fieldsUnlocked.value,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text('Back of Card:',
                style: GoogleFonts.neucha(
                  fontSize: 20,
                  color: kAccent,
                )),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(
            thickness: 0.5,
            color: kAccent,
          ),
        ),
        SliverToBoxAdapter(
          child: Text(
            statesAndCapital['$index']['a'],
            style: GoogleFonts.ubuntuMono(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}

class OpenCardController extends GetxController {
  final int index;
  OpenCardController(
    this.index,
  );
  RxBool fieldsUnlocked = RxBool(false);
  RxBool isFav = RxBool(false);

  late TextEditingController frontController =
      TextEditingController(text: statesAndCapital['$index']['q']);

  void toggleFields() {
    fieldsUnlocked.toggle();
    update();
  }

  void toggleFav() {
    isFav.toggle();
    update();
  }
}
