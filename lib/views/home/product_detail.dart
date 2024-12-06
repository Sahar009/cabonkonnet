import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/views/chat/message.dart';
import 'package:cabonconnet/views/investment/investment_calendar.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/build_image.dart';
import 'package:cabonconnet/views/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetails({super.key, required this.productModel});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ChatController chatController = Get.put(ChatController());
  String? currentUserId;
  @override
  void initState() {
    AppLocalStorage.getCurrentUserId().then((value) {
      setState(() {
        currentUserId = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              70.toHeightWhiteSpacing(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ProfileWidget(
                  name: widget.productModel.user?.fullName,
                  profilePic: widget.productModel.user?.profileImage,
                  country: widget.productModel.user?.country,
                  subTitle: "country",
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => InvestmentCalendar(
                          productModel: widget.productModel,
                        ));
                  },
                  child: Container(
                    height: 47,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColor.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Invest",
                        style: AppTextStyle.body(
                          size: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Product status:"),
                  ),
                  const Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: AppColor.yelow,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                          widget.productModel.level.toProductStatus())),
                ],
              ),
              Text(
                widget.productModel.name,
                style: AppTextStyle.soraBody(size: 16),
              ),
              15.toHeightWhiteSpacing(),
              Text(
                widget.productModel.description,
                style: AppTextStyle.soraBody(
                  size: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              15.toHeightWhiteSpacing(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Goal",
                    style: AppTextStyle.soraBody(size: 16),
                  ),
                  5.toHeightWhiteSpacing(),
                  Text(
                    widget.productModel.goals,
                    style: AppTextStyle.soraBody(
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              10.toHeightWhiteSpacing(),
              BuildImageWidget(imageUrls: widget.productModel.imageUrls),
              15.toHeightWhiteSpacing(),
              AppButton(
                onTab: () {},
                title: "Start a discussion",
              ),
              15.toHeightWhiteSpacing(),
              AppButton(
                onTab: () async {
                  var chatRoom = await chatController.initiateChat(
                      currentUserId!, widget.productModel.user?.id ?? "");
                  Get.to(() => MessagesScreen(
                        chatRoom: chatRoom,
                        currentUserId: currentUserId!,
                      ));
                },
                title: "Send a message",
                color: null,
                textColor: AppColor.primaryColor,
              ),
              50.toHeightWhiteSpacing()
            ],
          ),
        ),
      ),
    );
  }
}
