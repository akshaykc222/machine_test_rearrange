import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_test_rearrange/core/response_classify.dart';
import 'package:machine_test_rearrange/rearrange/presentation/manager/home_controller.dart';
import 'package:machine_test_rearrange/rearrange/presentation/router/app_pages.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;

  @override
  void initState() {
    controller = Provider.of<HomeController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Consumer<HomeController>(builder: (context, data, child) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D5C87)),
            onPressed: data.selectedProducts.length == 6
                ? () {
                    GoRouter.of(context).pushNamed(AppPages.reArrange);
                  }
                : null,
            child: Text(data.selectedProducts.length == 6
                ? "Rearrange"
                : "${data.selectedProducts.length}/6 Selected"),
          );
        }),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
            Consumer<HomeController>(
                builder: (context, data, child) => data
                            .categoryResponse.status ==
                        Status.LOADING
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: data.categoryResponse.data?.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    data.changeSelectedCat(
                                        data.categoryResponse.data![index]);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5, bottom: 6, top: 6),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: data.selectedCategory ==
                                                data.categoryResponse
                                                    .data![index]
                                            ? const Color(0xFF0D5C87)
                                            : null,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: const Color(0xFF0D5C87),
                                            width: 1.2)),
                                    child: Center(
                                      child: Text(
                                        data.categoryResponse.data?[index] ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: data.selectedCategory ==
                                                    data.categoryResponse
                                                        .data![index]
                                                ? Colors.white
                                                : const Color(0xFF0D5C87)),
                                      ),
                                    ),
                                  ),
                                )),
                      )),
            const SizedBox(
              height: 10,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Products",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
            Consumer<HomeController>(
                builder: (context, data, child) => data
                            .productResponse.status ==
                        Status.LOADING
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: GridView.builder(
                            itemCount: data.productResponse.data?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor: Colors.black54,
                                        title: Text(
                                          data.productResponse.data?[index]
                                                  .title ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Checkbox(
                                          value: data.selectedProducts.contains(
                                              data.productResponse
                                                  .data![index]),
                                          activeColor: const Color(0xFF0D5C87),
                                          // checkColor: const Color(0xFF0D5C87),
                                          onChanged: (value) {
                                            data.changeSelected(
                                                data.productResponse
                                                    .data![index],
                                                context: context);
                                          },
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Image.network(
                                          data.productResponse.data?[index]
                                                  .thumbnail ??
                                              "", // Replace with the actual image URL
                                          fit: BoxFit.contain,
                                          // width: 100,
                                          // height: 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))))
          ],
        ),
      ),
    );
  }
}
