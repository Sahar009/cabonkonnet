import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class NoDocument extends StatelessWidget {
  final String title;
  const NoDocument({super.key, this.title = "You have no team yet"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(AppImages.nofile),
          ),
          Text(
            title,
            style: AppTextStyle.body(size: 16),
          )
        ],
      ),
    );
  }
}

class NoDocumentScreen extends StatelessWidget {
  const NoDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NoDocument(),
    );
  }
}
