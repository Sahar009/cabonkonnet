// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class BuildImageWidget extends StatelessWidget {
//   final List<String> imageUrls;
//   const BuildImageWidget({super.key, required this.imageUrls});

//   @override
//   Widget build(BuildContext context) {
//     if (imageUrls.isEmpty) {
//       return Container(); // No images to show
//     } else if (imageUrls.length == 1) {
//       return SizedBox(
//         height: 250,
//         width: double.infinity,
//         child: CachedNetworkImage(
//           imageUrl: imageUrls[0],
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (imageUrls.length == 2) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: imageUrls
//             .map((url) => Expanded(
//                   child: CachedNetworkImage(
//                     imageUrl: url,
//                     fit: BoxFit.cover,
//                   ),
//                 ))
//             .toList(),
//       );
//     } else if (imageUrls.length == 3) {
//       return SizedBox(
//         height: 100, // Adjust height as needed
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: imageUrls.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 5),
//               child: CachedNetworkImage(
//                 imageUrl: imageUrls[index],
//                 fit: BoxFit.cover,
//                 width: 100, // Fixed width for each image
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       // For more than 3 images, use StaggeredGridView
//       return SizedBox(
//         height: 200, // Adjust height as needed
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // Two columns
//             childAspectRatio: 1, // Adjust aspect ratio
//             crossAxisSpacing: 4.0,
//             mainAxisSpacing: 4.0,
//           ),
//           itemCount: imageUrls.length,
//           itemBuilder: (context, index) {
//             return CachedNetworkImage(
//               imageUrl: imageUrls[index],
//               fit: BoxFit.cover,
//             );
//           },
//         ),
//       );
//     }
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class BuildImageWidget extends StatelessWidget {
//   final List<String> imageUrls;
//   const BuildImageWidget({super.key, required this.imageUrls});

//   @override
//   Widget build(BuildContext context) {
//     if (imageUrls.isEmpty) {
//       return Container(); // No images to show
//     } else if (imageUrls.length == 1) {
//       return SizedBox(
//         height: 250,
//         width: double.infinity,
//         child: CachedNetworkImage(
//           imageUrl: imageUrls[0],
//           fit: BoxFit.cover,
//         ),
//       );
//     } else {
//       return Column(
//         children: [
//           CarouselSlider.builder(
//             itemCount: imageUrls.length,
//             itemBuilder: (context, index, realIndex) {
//               return CachedNetworkImage(
//                 imageUrl: imageUrls[index],
//                 fit: BoxFit.cover,
//                 width: double.infinity, // Set fixed width
//                 height: 250, // Adjust height as needed
//               );
//             },
//             options: CarouselOptions(
//               height: 250,
//               autoPlay: true,

//               viewportFraction: 0.5, // Show one image at a time
//               enableInfiniteScroll: false, // Disable infinite scroll
//               enlargeCenterPage: false, // Don't enlarge the center page
//               initialPage: 0, // Start from the first image
//             ),
//           ),
//           const SizedBox(height: 10),
//           buildIndicator(imageUrls.length),
//         ],
//       );
//     }
//   }

//   Widget buildIndicator(int itemCount) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         itemCount,
//         (index) => AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           margin: EdgeInsets.symmetric(horizontal: 5),
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.grey.withOpacity(0.5),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class BuildImageWidget extends StatefulWidget {
  final List<String> imageUrls;
  const BuildImageWidget({super.key, required this.imageUrls});

  @override
  BuildImageWidgetState createState() => BuildImageWidgetState();
}

class BuildImageWidgetState extends State<BuildImageWidget> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(); // No images to show
    } else if (widget.imageUrls.length == 1) {
      return SizedBox(
        height: 250,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrls[0],
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Column(
        children: [
          FlutterCarousel(
            options: FlutterCarouselOptions(
              initialPage: 1,
              height: 250.0,
              showIndicator: false, // Disable default indicator
              // autoPlay: true, // Enable autoplay
              enlargeCenterPage: true, // Optional: Enlarge the center page
              viewportFraction: 0.5, // Show 2 images at a time
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          _buildCustomIndicator(widget.imageUrls.length),
        ],
      );
    }
  }

  Widget _buildCustomIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width:
              _currentIndex == index ? 25 : 12, // Make active indicator larger
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == index
                ? AppColor.primaryColor
                : Colors.grey, // Active color vs inactive color
          ),
        ),
      ),
    );
  }
}
