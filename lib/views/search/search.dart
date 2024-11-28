import 'package:cabonconnet/controllers/search_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:cabonconnet/views/home/product_detail.dart';
import 'package:cabonconnet/views/profile/profile_view.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Initialize the SearchController with a SearchRepository
  final AppSearchController searchController = Get.put(AppSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              10.toWidthWhiteSpacing(),
              const AppBackBotton(),
              SizedBox(
                height: 44,
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: TextField(
                  // ✅ Correct usage
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      searchController.search(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            //: MediaQuery.sizeOf(context).height * 0.8,
            child: Obx(() {
              // Handle loading state
              if (searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle error state 
              if (searchController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    searchController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Handle empty results
              if (searchController.searchResults.isEmpty) {
                return const Center(child: Text('No results found.'));
              }

              // Display results
              return ListView.builder(
                itemCount: searchController.searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchController.searchResults[index];
                  final type = result['type'];
                  final name = result['fullName'] ??
                      ((result['isProduct'] ?? false)
                          ? result['product']["name"]
                          : result["content"]) ??
                      result["title"];
                  final subtitle = type == 'user'
                      ? 'User'
                      : type == 'product'
                          ? (result['isProduct'] ? 'Product' : "Post")
                          : 'Event';

                  return ListTile(
                    leading: Icon(
                      type == 'user'
                          ? IconsaxPlusLinear.percentage_circle
                          : type == 'product'
                              ? IconsaxPlusLinear.align_bottom
                              : IconsaxPlusLinear.external_drive,
                      color: Colors.green,
                    ),
                    title: Text(
                      name ?? 'No Name',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(subtitle),
                    trailing:
                        const Icon(IconsaxPlusLinear.arrow_right_3, size: 16),
                    onTap: () {
                      if (type == 'user') {
                        Get.to(() => ProfileView(
                              userId: result['\$id'],
                              // userModel: UserModel.fromMap(result),
                            ));
                      } else if (type == 'product' &&
                          (result['isProduct'] ?? false)) {
                        Get.to(() => ProductDetails(
                              productModel: ProductModel.fromMap(result),
                            ));
                      } else if (type == 'event') {
                        Get.to(() => LiveEvent(
                              event: EventModel.fromMap(result),
                            ));
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
