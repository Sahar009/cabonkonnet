import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/nav_bar_contoller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/home/new_post.dart';
import 'package:cabonconnet/views/home/showcase_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Home extends StatelessWidget {
  final NavBarContoller contoller = Get.put(NavBarContoller());
  final ProfileController profileContoller = Get.put(ProfileController());

  Home({super.key});

  // Method to show the BottomSheet
  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40), // Reduced padding
        height: 180, // Adjust height if needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Custom drag handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const NewPost());
              },
              leading: const Icon(IconsaxPlusBold.edit),
              title: Text(
                "Create a post",
                style:
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShowcaseProduct()));
              },
              leading: const Icon(IconsaxPlusBold.tag),
              title: Text(
                "Showcase product",
                style:
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController()).reload();
    return Obx(() {
      return Scaffold(
        body: contoller.screens[contoller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: contoller.currentIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 2) {
              // If "Post" icon is tapped, show the BottomSheet
              _showPostOptions(context);
            } else {
              // Otherwise, update the current index as usual
              contoller.updateCurrentIndex(index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusLinear.home,
                color: contoller.checkCurrentState(0)
                    ? AppColor.black
                    : AppColor.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusLinear.calendar_2,
                color: contoller.checkCurrentState(1)
                    ? AppColor.black
                    : AppColor.grey,
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusLinear.add_square,
                color: contoller.checkCurrentState(2)
                    ? AppColor.black
                    : AppColor.grey,
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconsaxPlusLinear.message_minus,
                color: contoller.checkCurrentState(3)
                    ? AppColor.black
                    : AppColor.grey,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Obx(() {
                return CircleAvatar(
                  backgroundImage:
                      profileContoller.userModelRx.value?.profileImage != null
                          ? CachedNetworkImageProvider(
                              profileContoller.userModelRx.value!.profileImage!)
                          : AssetImage(AppImages.smallpicture2),
                  backgroundColor: contoller.checkCurrentState(4)
                      ? AppColor.black
                      : AppColor.grey,
                );
              }),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
