import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_test_rearrange/rearrange/data/models/product_model.dart';
import 'package:machine_test_rearrange/rearrange/presentation/manager/home_controller.dart';
import 'package:machine_test_rearrange/rearrange/presentation/utils/create_initial_positions.dart';
import 'package:machine_test_rearrange/rearrange/presentation/utils/sizeclass.dart';
import 'package:provider/provider.dart';

import '../../../injector.dart';

class ReArrangeScreen extends StatefulWidget {
  const ReArrangeScreen({super.key});

  @override
  State<ReArrangeScreen> createState() => _ReArrangeScreenState();
}

class _ReArrangeScreenState extends State<ReArrangeScreen> {
  List<Widget> _getWidgets(List<ProductModel> items) {
    var widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      widgets.add(
        ProductWidget(
          product: items[i],
          sizeClass: CreateInitialPos(index: i, context: context).createPost(),
          index: i,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Consumer<HomeController>(builder: (context, data, child) {
              return Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DottedBorder(
                    dashPattern: const [6, 6, 6, 6],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: LayoutBuilder(builder: (context, cons) {
                        SizeClass s = sl();
                        s.maxHeight = cons.maxHeight;
                        s.maxWidth = cons.maxWidth;

                        return Stack(
                            children: _getWidgets(data.selectedProducts));
                      }),
                    ),
                  ),
                ),
              );
            }),
            const Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.back_hand_rounded,
                      color: Colors.black,
                    ),
                    Text(
                      "Tap to move items",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )
                  ],
                ))
          ],
        ));
  }
}

class ProductWidget extends StatefulWidget {
  final ProductModel product;
  final Offset sizeClass;
  final int index;
  const ProductWidget(
      {required this.product,
      super.key,
      required this.sizeClass,
      required this.index});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  ValueNotifier<double> scaleFactor = ValueNotifier(1.0);
  late ValueNotifier<double> top;
  late ValueNotifier<double> left;
  SizeClass sc = sl();
  @override
  void initState() {
    top = ValueNotifier(widget.sizeClass.dy);
    left = ValueNotifier(widget.sizeClass.dx);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: top,
        builder: (context, topData, child) {
          return ValueListenableBuilder(
              valueListenable: left,
              builder: (context, leftData, child) {
                return AnimatedPositioned(
                    top: topData,
                    left: leftData,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        var bound = CreateInitialPos.checkBounds(
                            details.globalPosition,
                            sc.maxWidth,
                            sc.maxHeight,
                            MediaQuery.of(context).size.width * 0.29,
                            150);
                        left.value = bound.dx;
                        top.value = bound.dy;
                      },
                      child: ValueListenableBuilder(
                          valueListenable: scaleFactor,
                          builder: (context, data, child) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.29,
                              height: 150,
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                widget.product.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    ));
              });
        });
  }
}
