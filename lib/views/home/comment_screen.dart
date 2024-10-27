import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/views/home/new_post.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/post_wiget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CommentScreen extends StatefulWidget {
  final PostModel postModel;
  const CommentScreen({super.key, required this.postModel});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              const SizedBox(height: 5),
              PostWidget(postModel: widget.postModel),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 10),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image(image: AssetImage(AppImages.smallpicture1)),
                const SizedBox(width: 5),
                Container(
                  height: 130,
                  width: 330,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xffF5F5F5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Angela Valdes',
                            style: AppTextStyle.body(
                                size: 16, fontWeight: FontWeight.w500)),
                        Text('Founder',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal)),
                        const SizedBox(height: 5),
                        Text(
                            'What are the odds or success rate of this project? Looking at the scope of what we looking to acheive?',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 150),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewPost()));
                      },
                      child: Image(image: AssetImage(AppImages.smallpicture2))),
                  Expanded(
                    child: TextFormField(
                        style: AppTextStyle.body(
                            fontWeight: FontWeight.normal, size: 12),
                        decoration: InputDecoration(
                            hintText: 'Add comment',
                            hintStyle: AppTextStyle.body(
                                size: 12, fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: const Color(0xffF5F5F5),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)))),
                  ),
                  const SizedBox(width: 40),
                  const Icon(IconsaxPlusBold.send_2)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
