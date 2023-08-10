import 'package:flutter/material.dart';

import '../../repository/customer_details_repo/customer_profile_repo.dart';
import '../../repository/customer_details_repo/shopping_item_repo.dart';


class ShoppingItemService extends ChangeNotifier {
  final ShoppingItemRepo shoppingItemRepo;

  ShoppingItemService({required this.shoppingItemRepo});

  Future getShoppingItemService(String userId) async {
    return await shoppingItemRepo.getShoppingItemRepo(userId);
  }

}
