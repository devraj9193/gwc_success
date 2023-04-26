
import '../../controller/api_service.dart';

class SuccessMemberProfileRepository{
  ApiClient apiClient;

  SuccessMemberProfileRepository({required this.apiClient}) : assert(apiClient != null);

  Future getUserProfileRepo(String accessToken) async{
    return await apiClient.getSuccessMemberProfileApi(accessToken);
  }
}