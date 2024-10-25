// import 'package:cabonconnet/constant/app_color.dart';
// import 'package:cabonconnet/constant/app_images.dart';
// import 'package:cabonconnet/nav_provider/nav_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax_plus/iconsax_plus.dart';

// class NavBar extends StatefulWidget {
//   const NavBar({super.key});

//   @override
//   State<NavBar> createState() => _NavBarState();
// }

// class _NavBarState extends State<NavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NavProvider>(builder: (context, navProvider, _) {
//       return Scaffold(
//         body: navProvider.screens[navProvider.currentIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: navProvider.currentIndex,
//           onTap: navProvider.updateCurrentIndex,
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   IconsaxPlusLinear.home,
//                   color: navProvider.checkCurrentState(0)
//                       ? AppColor.black
//                       : AppColor.grey,
//                 ),
//                 label: 'Home'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   IconsaxPlusLinear.calendar_2,
//                   color: navProvider.checkCurrentState(1)
//                       ? AppColor.black
//                       : AppColor.grey,
//                 ),
//                 label: 'Events'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   IconsaxPlusLinear.add_square,
//                   color: navProvider.checkCurrentState(2)
//                       ? AppColor.black
//                       : AppColor.grey,
//                 ),
//                 label: 'Post'),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   IconsaxPlusLinear.message_minus,
//                   color: navProvider.checkCurrentState(3)
//                       ? AppColor.black
//                       : AppColor.grey,
//                 ),
//                 label: 'Chats'),
//             BottomNavigationBarItem(
//                 icon: Image(
//                   image: AssetImage(AppImages.smallpicture2),
//                   color: navProvider.checkCurrentState(4)
//                       ? AppColor.black
//                       : AppColor.grey,
//                 ),
//                 label: 'Profile'),
//           ],
//         ),
//       );
//     });
//   }
// }
