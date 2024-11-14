import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/custom_dialog.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController postController = Get.put(PostController());
  TextEditingController addressController = TextEditingController();
  PageController pageController = PageController();
  bool isPost = true;

  // Refresh function
  Future<void> _refreshPosts() async {
    await postController.fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const Image(image: AssetImage(AppImages.homelogo)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.filledColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 35,
                    child: const Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.search_normal,
                          size: 15,
                        ),
                        SizedBox(width: 10),
                        Text("Search"),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CustomDialog.error();
                  },
                  child: SvgPicture.asset(AppImages.notify),
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabButton(
                  isActive: isPost,
                  onTap: () {
                    setState(() {
                      isPost = true;
                    });
                    pageController.jumpToPage(0);
                  },
                  title: "All posts",
                ),
                const SizedBox(width: 20),
                TabButton(
                  isActive: !isPost,
                  onTap: () {
                    setState(() {
                      isPost = false;
                    });
                    pageController.jumpToPage(1);
                  },
                  title: "All products",
                ),
              ],
            ),
            const Divider(),
            // Use RefreshIndicator around ListView
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPosts,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: PageView(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            isPost = index == 0;
                          });
                        },
                        children: const [
                          AllPost(),
                          AllProduct(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
