import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/profile/edit_profile.dart';
import 'package:cabonconnet/views/team/team_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetails extends StatefulWidget {
  final UserModel user;
  final bool isOrg;
  const ProfileDetails({super.key, required this.user, this.isOrg = false});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back_ios)),
                    Text(
                      widget.isOrg ? "Organization" : "Profile Details",
                      style: AppTextStyle.body(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => EditProfile(
                          user: widget.user,
                          isOrg: widget.isOrg,
                        ));
                  },
                  child: Text("Edit profile",
                      style: AppTextStyle.body(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          widget.isOrg
              ? Container(
                  height: 130,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColor.filledColor,
                    borderRadius: BorderRadius.circular(8),
                    image: widget.user.businessLogoUrl != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.user.businessLogoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                )
              : Center(
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: widget.user.profileImage != null
                        ? CachedNetworkImageProvider(widget.user.profileImage!)
                        : null,
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
          const Divider(),
          const SizedBox(
            height: 30,
          ),
          widget.isOrg
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ProfileLabel(
                          label: "Busness Name",
                          name: widget.user.companyName ?? ""),
                      ProfileLabel(
                          label: "Country", name: widget.user.country ?? ""),
                      ProfileLabel(
                          label: "Business Reg number",
                          name: widget.user.businessRegNumber ?? ""),
                      ProfileLabel(
                          label: "Website", name: widget.user.website ?? ""),
                      ProfileLabel(
                        label: "Team",
                        name:
                            "${widget.user.teamMembers!.length.toString()}  members",
                        onTap: () {
                          Get.to(
                            () => TeamScreen(
                              userId: widget.user.id,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      ProfileLabel(label: "Name", name: widget.user.fullName),
                      ProfileLabel(label: "Email", name: widget.user.email),
                      ProfileLabel(
                          label: "Phone number", name: widget.user.phoneNumber),
                      ProfileLabel(
                          label: "Address", name: widget.user.address ?? ""),
                      ProfileLabel(label: "Bio", name: widget.user.bio ?? "")
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class ProfileLabel extends StatelessWidget {
  const ProfileLabel(
      {super.key,
      required this.label,
      required this.name,
      this.teamCount,
      this.onTap});

  final String label;
  final String name;
  final int? teamCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.body(size: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppTextStyle.body(
                    size: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textColor),
              ),
              if (label == "Team")
                GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "See team",
                      style: AppTextStyle.body(
                        size: 14,
                        color: AppColor.primaryColor,
                      ),
                    ))
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
