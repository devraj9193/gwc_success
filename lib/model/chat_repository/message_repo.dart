import '../../controller/api_service.dart';

class MessageRepository {
  ApiClient apiClient;

  MessageRepository({required this.apiClient});

  Future getChatGroupIdRepo(String userId) async {
    return await apiClient.getChatGroupId(userId);
  }

  Future getGwcTeamChatGroupIdRepo(String userId) async {
    return await apiClient.getGwcTeamChatGroupId(userId);
  }
}
