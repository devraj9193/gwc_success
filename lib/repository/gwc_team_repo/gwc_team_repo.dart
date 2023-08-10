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

class GwcTeamRepo {
  ApiClient apiClient;

  GwcTeamRepo({required this.apiClient}) : assert(apiClient != null);

  Future getDoctorListRepo() async{
    return await apiClient.getDoctorListApi();
  }

  Future getSuccessListRepo() async{
    return await apiClient.getSuccessListApi();
  }

}