import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallControlSheet extends StatefulWidget {
  const IsmCallControlSheet({
    super.key,
    required this.controls,
    required this.collapseIndexOrder,
    required this.isControlsBottom,
  });

  // assert(
  //         controls.length >= collapseIndexOrder.length,
  //         'Passed order must contain each index atmost once',
  //       ),
  // assert(
  //   collapseIndexOrder.length == collapseIndexOrder.toSet().length,
  //   '`collapseIndexOrder` must not contain any duplicates',
  // ),
  // assert(collapseIndexOrder.every((e) => e < controls.length),
  //     'All indexes inside `collapseIndexOrder` must be within the range of `controls` list.');

  final List<Widget> controls;
  final List<int> collapseIndexOrder;
  final bool isControlsBottom;

  @override
  State<IsmCallControlSheet> createState() => IsmCallControlSheetState();
}

class IsmCallControlSheetState extends State<IsmCallControlSheet> {
  final RxBool _isCollapsed = true.obs;
  bool get isCollapsed => _isCollapsed.value;
  set isCollapsed(bool value) {
    if (value == isCollapsed) {
      return;
    }
    _isCollapsed.value = value;
  }

  void toggleCollapse([bool? value]) {
    isCollapsed = !(value ?? isCollapsed);
  }

  List<Widget> get collapsedControls => List.generate(
        widget.collapseIndexOrder.length,
        (index) => widget.controls[widget.collapseIndexOrder[index]],
      );

  List<Widget> get controls => isCollapsed && widget.isControlsBottom
      ? collapsedControls
      : widget.controls;

  @override
  void initState() {
    super.initState();
    toggleCollapse(!widget.isControlsBottom);
  }

  @override
  Widget build(BuildContext context) => Obx(
        () {
          final isMobile = MediaQuery.of(context).size.width < 800;
          return Container(
            width: widget.isControlsBottom
                ? Get.width
                : isMobile
                    ? Get.width / 2
                    : IsmCallDimens.sixty,
            decoration: BoxDecoration(
              color: (isCollapsed || !widget.isControlsBottom)
                  ? Colors.transparent
                  : context.theme.canvasColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  IsmCallDimens.sixteen,
                ),
              ),
            ),
            key: const ObjectKey('sheet_card_wrapper'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isControlsBottom) ...[
                  IsmCallTapHandler(
                    onTap: toggleCollapse,
                    child: Padding(
                      padding: IsmCallDimens.edgeInsets8,
                      child: Icon(
                        isCollapsed
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        key: const ObjectKey('sheet_icon'),
                      ),
                    ),
                  ),
                ],
                SafeArea(
                  top: false,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.isControlsBottom
                          ? isCollapsed
                              ? 5
                              : 3
                          : 1,
                      childAspectRatio: widget.isControlsBottom
                          ? isCollapsed
                              ? 1.2
                              : 1.8
                          : 1,
                    ),
                    padding: isCollapsed
                        ? IsmCallDimens.edgeInsets16_0
                        : IsmCallDimens.edgeInsets0,
                    itemCount: controls.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => UnconstrainedBox(
                      child: controls[index],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
