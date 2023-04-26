import 'package:flutter/cupertino.dart';
import 'package:gwc_success_team/model/success_user_model/success_member_profile_repository.dart';

class SuccessMemberProfileService extends ChangeNotifier{
  final SuccessMemberProfileRepository repository;

  SuccessMemberProfileService({required this.repository}) : assert(repository != null);

  Future getSuccessMemberProfileService(String accessToken) async{
    return await repository.getUserProfileRepo(accessToken);
  }
}