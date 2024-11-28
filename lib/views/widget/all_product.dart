import 'package:cabonconnet/controllers/product_controller.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/views/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({
    super.key,
  });

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  ProductController postController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (postController.posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }
        return ListView.builder(
          itemCount: postController.posts.length,
          itemBuilder: (context, index) {
            List<ProductModel> posts = postController.posts;
            ProductModel post = posts[index];
            return ProductWidget(
              productModel: post,
            );
          },
        );
      }),
    );
  }
}
