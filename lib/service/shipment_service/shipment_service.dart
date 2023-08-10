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
import '../../repository/shipment_repo/shipment_repo.dart';

class ShipmentService extends ChangeNotifier {
  late final ShipmentRepo shipmentRepo;

  ShipmentService({required this.shipmentRepo});

  Future getShipmentService() async {
    return await shipmentRepo.getShipmentRepo();
  }

  Future getShoppingItemService(String userId) async {
    return await shipmentRepo.getShoppingItemRepo(userId);
  }
}
