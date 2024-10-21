import 'package:cabonconnet/home/new_post.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:cabonconnet/widget/app_button.dart';
import 'package:flutter/material.dart';

class ShowcaseProduct extends StatefulWidget {
  const ShowcaseProduct({super.key});

  @override
  State<ShowcaseProduct> createState() => _ShowcaseProductState();
}

class _ShowcaseProductState extends State<ShowcaseProduct> {
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
                'Showcase Product',
                style: AppTextStyle.body(size: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const ProfileWidget(),
              const SizedBox(height: 7),
              const Divider(),
              const SizedBox(height: 15),
              Text(
                'Product Name',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  decoration: InputDecoration(
                      hintText: 'Enter product name',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 15),
              Text(
                'Product Description',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  maxLines: 9,
                  decoration: InputDecoration(
                      hintText: 'Describe your product',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 15),
              Text(
                'Product Level',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  decoration: InputDecoration(
                      hintText: 'Not started',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 15),
              Text(
                'Product Goals',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  maxLines: 9,
                  decoration: InputDecoration(
                      hintText: 'Describe your product goals',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 15),
              Text(
                'Funds Needed',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  decoration: InputDecoration(
                      hintText: 'Enter amount needed',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 15),
              Text(
                'Product Impact',
                style: AppTextStyle.body(size: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                  style: AppTextStyle.body(
                      fontWeight: FontWeight.normal, size: 12),
                  maxLines: 9,
                  decoration: InputDecoration(
                      hintText: 'Describe product impact',
                      hintStyle: AppTextStyle.body(
                          size: 14, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: const Color(0xffF5F5F5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)))),
              const SizedBox(height: 50),
              AppButton(onTab: () {}),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
