import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/home/home.dart';
import 'package:cabonconnet/home/new_post.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
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
              PostWidget(
                  name: 'Tony Thompson',
                  location: 'Texas USA',
                  profilePicture: AppImages.tasha,
                  status:
                      'Switching to clean energy is no longer just a choice-its a necessity for our planet! From solar panels to wind turbines. Every small steps counts. Are you ready to make the switch? #CleanEnergy # Sustainability # GoGreen #Renewables #ClimateAction',
                  statusImage: AppImages.picture,
                  likes: '11',
                  comment: '8',
                  share: '5'),
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

class PostWidget extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String location;
  final String status;
  final String statusImage;
  final String likes;
  final String comment;
  final String share;
  const PostWidget(
      {super.key,
      required this.name,
      required this.location,
      required this.profilePicture,
      required this.status,
      required this.statusImage,
      required this.likes,
      required this.comment,
      required this.share});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image(image: AssetImage(profilePicture)),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyle.body(fontWeight: FontWeight.w500),
                ),
                Text(location)
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          status,
          style: AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 5),
        Image(image: AssetImage(statusImage)),
        const SizedBox(height: 7),
        Row(
          children: [
            const Icon(Icons.favorite_border, size: 16),
            const SizedBox(width: 3),
            Text(likes,
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal)),
            const Spacer(),
            Text('$comment comments',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal)),
            const SizedBox(width: 5),
            const Icon(Icons.circle, size: 6),
            const SizedBox(width: 5),
            Text('$share shares',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal))
          ],
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserButton(iconData: IconsaxPlusLinear.like_1, text: 'Like'),
              UserButton(iconData: IconsaxPlusLinear.share, text: 'Share'),
              UserButton(iconData: IconsaxPlusLinear.send_2, text: 'Send'),
              UserButton(iconData: IconsaxPlusLinear.document, text: 'Save'),
            ],
          ),
        ),
      ],
    );
  }
}
