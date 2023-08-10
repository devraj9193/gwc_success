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

class CustomerStatusRepo {
  ApiClient apiClient;

  CustomerStatusRepo({required this.apiClient}) : assert(apiClient != null);

  Future getAllCustomerListRepo() async{
    return await apiClient.getAllCustomerListApi();
  }

  Future getClaimedCustomerListRepo() async{
    return await apiClient.getClaimedCustomerListApi();
  }

  Future getUnClaimedCustomerListRepo() async{
    return await apiClient.getUnClaimedCustomerListApi();
  }

  Future sendClaimCustomerRepo(String userId) async{
    return await apiClient.sendClaimCustomerApi(userId);
  }

  Future getConsultationPendingListRepo() async{
    return await apiClient.getConsultationPendingListApi();
  }

  Future getShipmentListRepo() async{
    return await apiClient.getShipmentListApi();
  }

  Future getMealActiveListRepo() async{
    return await apiClient.getMealActiveListApi();
  }

  Future getPostProgramListRepo() async{
    return await apiClient.getPostProgramListApi();
  }

}