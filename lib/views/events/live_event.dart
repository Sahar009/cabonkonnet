import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class LiveEvent extends StatefulWidget {
  const LiveEvent({super.key});

  @override
  State<LiveEvent> createState() => _LiveEventState();
}

class _LiveEventState extends State<LiveEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          Stack(
                      children: [
          Image(image: AssetImage(AppImages.liveimage)),
          Positioned(
            bottom: 5,
            left: 15,
            child: Row(
              children: [
                Image(image: AssetImage(AppImages.redcircle)),
                const SizedBox(width: 5),
                Text(
                  'Live',
                  style: AppTextStyle.body(
                      color: AppColor.white,
                      size: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
                      ],
                    ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Innovations in Solar Energy Storage',
                        style: AppTextStyle.body(fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(Icons.more_vert)
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image(image: AssetImage(AppImages.smallpicture2)),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Terry Silver',
                            style: AppTextStyle.body(size: 15)),
                        Row(
                          children: [
                            Text(
                              'Host',
                              style: AppTextStyle.body(
                                  fontWeight: FontWeight.normal, size: 13),
                            ),
                            const SizedBox(width: 5),
                            Image(
                              image: AssetImage(AppImages.mic),
                              height: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.remove_red_eye_outlined),
                    const SizedBox(width: 5),
                    Text(
                      '700',
                      style: AppTextStyle.body(size: 12),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
