import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String? _selectedDeleteReason;
  final TextEditingController _otherReasonController = TextEditingController();

  final List<String> _deleteReasons = [
    'I am no longer interested in using my account',
    'I am no longer enjoying the platform',
    'I want to change my details',
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  Text(
                    "Delete account",
                    style: AppTextStyle.body(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "We are really sorry to see you go. Are you sure you \nwant to delete your account? Once you confirm, \nyour data will be gone.",
                style: AppTextStyle.body(size: 14),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _deleteReasons.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDeleteReason = _deleteReasons[index];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                _selectedDeleteReason == _deleteReasons[index]
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: _selectedDeleteReason ==
                                        _deleteReasons[index]
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _deleteReasons[index],
                                  style: AppTextStyle.body(
                                    size: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),

                      // Show text field if "Other" is selected
                      if (_selectedDeleteReason == "Other" &&
                          _deleteReasons[index] == "Other")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0)
                              .copyWith(top: 50),
                          child: TextField(
                            controller: _otherReasonController,
                            maxLines: 5,
                            minLines: 5,
                            decoration: const InputDecoration(
                              labelText: "Please specify your reason",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 60),
              AppButton(onTab:(){})
            ],
          ),
        ),
      ),
    );
  }
}
