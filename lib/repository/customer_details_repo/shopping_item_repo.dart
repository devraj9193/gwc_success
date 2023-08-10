// import '../../service/api_service.dart';
//
// class uvDeskRepository{
//   ApiClient apiClient;
//
//   uvDeskRepository({required this.apiClient}) : assert(apiClient != null);
//
//   Future uvDeskTicketRaiseRepo(String description, String title) async{
//     return await apiClient.uvDeskTicketRaiseApi(description, title);
//   }
// }

import '../../service/api_service.dart';

class ShoppingItemRepo {
  ApiClient apiClient;

  ShoppingItemRepo({required this.apiClient}) : assert(apiClient != null);

  Future getShoppingItemRepo(String userId) async{
    return await apiClient.getShoppingItemApi(userId);
  }

}