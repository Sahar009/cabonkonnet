import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/team_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/team_member_model.dart';
import 'package:cabonconnet/views/team/create_team.dart';
import 'package:cabonconnet/views/widget/no_file.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamScreen extends StatefulWidget {
  final String userId;
  const TeamScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  // Initialize the TeamController to access team data
  final TeamController teamController = Get.put(TeamController());
  String? currentUserId;
  @override
  void initState() {
    AppLocalStorage.getCurrentUserId().then((value) {
      setState(() {
        currentUserId = value;
      });
    });
    teamController.updateId(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Row(
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
                      "Team members",
                      style: AppTextStyle.body(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                if (currentUserId == widget.userId)
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CreateTeam());
                    },
                    child: Text("Add Member",
                        style: AppTextStyle.body(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500,
                            size: 15)),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Team members list
            Expanded(
              child: Obx(() {
                if (teamController.isBusy.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (teamController.teams.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const NoDocument(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0)
                            .copyWith(top: 23),
                        child: AppButton(
                          onTab: () {
                            Get.to(() => const CreateTeam());
                          },
                          title: "Add Member",
                        ),
                      )
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: teamController.teams.length,
                  itemBuilder: (context, index) {
                    TeamMemberModel member = teamController.teams[index];
                    return Column(
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(member.profilePic),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.fullName.capitalizeFirst ?? "",
                                style: AppTextStyle.body(),
                              ),
                              const SizedBox(
                                height: 1.8,
                              ),
                              Text(
                                member.position,
                                style: AppTextStyle.body(
                                  size: 13,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff4F4E4E),
                                ),
                              ),
                              const SizedBox(
                                height: 1.8,
                              ),
                              Text(
                                member.location,
                                style: AppTextStyle.body(
                                  size: 13,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff4F4E4E),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ]),
                        const CustomDivider(),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
