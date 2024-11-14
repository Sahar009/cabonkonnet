import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuildImageWidget extends StatelessWidget {
  final List<String> imageUrls;
  const BuildImageWidget( {super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {

    if (imageUrls.isEmpty) {
      return Container(); // No images to show
    } else if (imageUrls.length == 1) {
      return SizedBox(
        height: 250,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrls[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrls.length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: imageUrls
            .map((url) => Expanded(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                  ),
                ))
            .toList(),
      );
    } else if (imageUrls.length == 3) {
      return SizedBox(
        height: 100, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                width: 100, // Fixed width for each image
              ),
            );
          },
        ),
      );
    } else {
      // For more than 3 images, use StaggeredGridView
      return SizedBox(
        height: 200, // Adjust height as needed
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            childAspectRatio: 1, // Adjust aspect ratio
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }
  }
}

