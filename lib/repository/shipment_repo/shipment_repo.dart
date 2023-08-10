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

class ShipmentRepo {
  ApiClient apiClient;

  ShipmentRepo({required this.apiClient}) : assert(apiClient != null);

  Future getShipmentRepo() async{
    return await apiClient.getShipmentListApi();
  }

  Future getShoppingItemRepo(String userId) async{
    return await apiClient.getShoppingItemApi(userId);
  }
}