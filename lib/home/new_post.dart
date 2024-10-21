import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/home/showcase_product.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Text(
                'Create a post',
                style: AppTextStyle.body(size: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const ProfileWidget(),
              const SizedBox(height: 7),
              const Divider(),
              TextFormField(
                style:
                    AppTextStyle.body(size: 14, fontWeight: FontWeight.normal),
                maxLines: 25,
                decoration: InputDecoration(
                  hintText: 'Write your post...',
                  hintStyle: AppTextStyle.body(
                      size: 12, fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(IconsaxPlusLinear.image, size: 20),
                  const SizedBox(width: 6),
                  Text('Select image',
                      style: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal)),
                  const SizedBox(width: 20),
                  Text('# Hastag',
                      style: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ShowcaseProduct()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Post',
                          style: AppTextStyle.body(
                              color: AppColor.white,
                              size: 14,
                              fontWeight: FontWeight.normal)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(image: AssetImage(AppImages.tasha)),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tony Thompson',
                style: AppTextStyle.body(fontWeight: FontWeight.w500)),
            Text('Post to everyone',
                style: AppTextStyle.body(fontWeight: FontWeight.w500, size: 14))
          ],
        ),
      ],
    );
  }
}
