import 'package:flutter/material.dart';
import '../chat_repository/message_repo.dart';

class ChatService extends ChangeNotifier{
  late final MessageRepository repository;

  ChatService({required this.repository});

  Future getChatGroupIdService(String userId) async{
    return await repository.getChatGroupIdRepo(userId);
  }

  Future getGwcTeamChatGroupIdService(String userId) async{
    return await repository.getGwcTeamChatGroupIdRepo(userId);
  }

  Future getAccessToken(String kaleyraUID) async{
    return await repository.getAccessTokenRepo(kaleyraUID);
  }
}