import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'comfirm_ckeckout.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/widget/widget.dart';

class BuyTicket extends StatefulWidget {
  final EventModel event;
  const BuyTicket({super.key, required this.event});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  int ticketCount = 1;
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackBotton(
                pageTitle: "Ticket Details",
              ),
              10.toHeightWhiteSpacing(),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'First name',
                      hint: "Enter first Name",
                      prefixIcon: IconsaxPlusLinear.profile,
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      label: 'Last name',
                      hint: "Enter last Name",
                      prefixIcon: IconsaxPlusLinear.profile,
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: 'Email',
                hint: "Enter email address",
                prefixIcon: IconsaxPlusLinear.sms,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                label: 'Confirm email',
                hint: "Confirm email address",
                prefixIcon: IconsaxPlusLinear.sms,
                controller: confirmEmailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm email is required';
                  }
                  if (value != emailController.text) {
                    return 'Emails do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No. of tickets',
                    style: AppTextStyle.soraBody(
                      fontWeight: FontWeight.normal,
                      size: 15,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Container(
                          decoration:
                              const BoxDecoration(color: AppColor.filledColor),
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                        ),
                        onPressed: ticketCount > 1
                            ? () => setState(() => ticketCount--)
                            : null,
                      ),
                      Text(
                        ticketCount.toString(),
                        style: AppTextStyle.soraBody(
                          fontWeight: FontWeight.normal,
                          size: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_box_rounded,
                          color: AppColor.primaryColor,
                        ),
                        onPressed: () => setState(() => ticketCount++),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                onTab: () {
                  if (_formKey.currentState!.validate()) {
                    // Navigate to CheckoutPage if validation passes
                    Get.to(() => CheckoutPage(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          ticketCount: ticketCount,
                          ticketPrice: widget.event.ticketPrice!,
                        ));
                  }
                },
                title: "Check out",
              ),
              50.toHeightWhiteSpacing(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.soraBody(
            fontWeight: FontWeight.normal,
            size: 15,
          ),
        ),
        10.toHeightWhiteSpacing(),
        TextFormField(
          style: AppTextStyle.soraBody(
            fontWeight: FontWeight.normal,
          ),
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            fillColor: AppColor.filledColor,
            filled: true,
            hintText: hint,
            hintStyle: AppTextStyle.soraBody(
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(prefixIcon),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
