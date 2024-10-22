import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/views/home/posts.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Image(image: AssetImage(AppImages.homelogo)),
                  Expanded(
                    child: AppTextFields(
                        controller: addressController,
                        hint: 'Search',
                        iconData: IconsaxPlusLinear.search_normal_1),
                  ),
                  const Icon(IconsaxPlusLinear.notification)
                ],
              ),
              const SizedBox(height: 5),
              HomeWidget(
                profilePicture: AppImages.tasha,
                name: 'Tony Thompson',
                location: 'Texas USA',
                statusImage: AppImages.picture,
                status:
                    'Switching to clean energy is no longer just a choice-its a necessity for our planet! From solar panels to wind turbines. Every small steps counts. Are you ready to make the switch? #CleanEnergy # Sustainability # GoGreen #Renewables #ClimateAction',
                likes: '7',
                comment: '10',
                share: '7',
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 5),
              const SizedBox(height: 5),
              HomeWidget(
                profilePicture: AppImages.tasha,
                name: 'Tasha Patrick',
                location: 'New York USA',
                statusImage: AppImages.picture,
                status:
                    'Switching to clean energy is no longer just a choice-its a necessity for our planet! From solar panels to wind turbines. Every small steps counts. Are you ready to make the switch? #CleanEnergy # Sustainability # GoGreen #Renewables #ClimateAction',
                likes: '17',
                comment: '5',
                share: '30',
              ),
              const SizedBox(height: 5),
              const Divider(thickness: 5),
              const SizedBox(height: 5),
              HomeWidget(
                profilePicture: AppImages.tasha,
                name: 'Mr. Ibukun Tutor Nla',
                location: 'Ibadan Naija',
                statusImage: AppImages.picture,
                status:
                    'Switching to clean energy is no longer just a choice-its a necessity for our planet! From solar panels to wind turbines. Every small steps counts. Are you ready to make the switch? #CleanEnergy # Sustainability # GoGreen #Renewables #ClimateAction',
                likes: '7',
                comment: '10',
                share: '7',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String location;
  final String status;
  final String statusImage;
  final String likes;
  final String comment;
  final String share;
  const HomeWidget(
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Posts()));
      },
      child: Column(
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
                  Text(
                    location,
                  )
                ],
              ),
              const Spacer(),
              const Icon(IconsaxPlusLinear.menu)
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
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal)),
              const Spacer(),
              Text('$comment comments',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal)),
              const SizedBox(width: 5),
              const Icon(Icons.circle, size: 6),
              const SizedBox(width: 5),
              Text('$share shares',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal))
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserButton(iconData: IconsaxPlusLinear.like_1, text: 'Like'),
                UserButton(
                    iconData: IconsaxPlusLinear.message, text: 'Comment'),
                UserButton(iconData: IconsaxPlusLinear.share, text: 'Share'),
                UserButton(iconData: IconsaxPlusLinear.send_2, text: 'Send'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  const UserButton({
    super.key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(iconData, size: 20),
        Text(text,
            style: AppTextStyle.body(size: 13, fontWeight: FontWeight.normal))
      ],
    );
  }
}
