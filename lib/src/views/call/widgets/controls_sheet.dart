import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallControlSheet extends StatefulWidget {
  const IsmCallControlSheet({
    super.key,
    required this.controls,
    required this.collapseIndexOrder,
    required this.isControlsBottom,
    required this.isMobile,
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
  final bool isMobile;

  @override
  State<IsmCallControlSheet> createState() => IsmCallControlSheetState();
}

class IsmCallControlSheetState extends State<IsmCallControlSheet> {
  final RxBool _isCollapsed = true.obs;
  bool get isCollapsed => _isCollapsed.value;
  set isCollapsed(bool value) {
    if (value == isCollapsed) return;
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
    toggleCollapse(widget.isMobile ? !widget.isControlsBottom : true);
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => Container(
          width: widget.isControlsBottom
              ? widget.isMobile
                  ? Get.width
                  : Get.width / 2
              : IsmCallDimens.sixty,
          decoration: BoxDecoration(
            color: isCollapsed || !widget.isControlsBottom
                ? Colors.transparent
                : widget.isMobile
                    ? context.theme.canvasColor
                    : Colors.transparent,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(IsmCallDimens.sixteen),
            ),
          ),
          key: const ObjectKey('sheet_card_wrapper'),
          child: controls.length > 5
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isControlsBottom && widget.isMobile) ...[
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
                      child: widget.isMobile
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: widget.isControlsBottom
                                    ? isCollapsed
                                        ? widget.isMobile
                                            ? 5
                                            : 7
                                        : 3
                                    : 1,
                                childAspectRatio: widget.isControlsBottom
                                    ? isCollapsed
                                        ? widget.isMobile
                                            ? 1.2
                                            : 1
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
                            )
                          : Padding(
                              padding: IsmCallDimens.edgeInsetsB25,
                              child: Row(
                                spacing: IsmCallDimens.twenty,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controls.length,
                                  (index) => UnconstrainedBox(
                                    child: controls[index],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                )
              : Padding(
                  padding: IsmCallDimens.edgeInsetsB25,
                  child: Row(
                    spacing: IsmCallDimens.twenty,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      controls.length,
                      (index) => UnconstrainedBox(child: controls[index]),
                    ),
                  ),
                ),
        ),
      );
}
