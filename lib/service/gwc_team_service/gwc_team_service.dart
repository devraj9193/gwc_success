// import 'package:flutter/material.dart';
//
// import '../../repository/uvDesk_repo/uvDesk_repository.dart';
//
// class UvDeskService extends ChangeNotifier{
//   late final uvDeskRepository repository;
//
//   UvDeskService({required this.repository});
//
//
//
//   Future getTicketListService(String customerId) async{
//     return await repository.uvDeskTicketRaiseRepo(customerId);
//   }
// }

import 'package:flutter/cupertino.dart';
import '../../repository/customer_status_repo.dart/customer_status_repo.dart';
import '../../repository/gwc_team_repo/gwc_team_repo.dart';

class GwcTeamService extends ChangeNotifier {
  late final GwcTeamRepo gwcTeamRepo;

  GwcTeamService({required this.gwcTeamRepo});

  Future getAllCustomerService() async {
    return await gwcTeamRepo.getDoctorListRepo();
  }

  Future getSuccessListService() async {
    return await gwcTeamRepo.getSuccessListRepo();
  }

}
