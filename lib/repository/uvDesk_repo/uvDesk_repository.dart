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

import 'dart:io';

import '../../service/api_service.dart';

class UvDeskRepo {
  ApiClient apiClient;

  UvDeskRepo({required this.apiClient}) : assert(apiClient != null);

  Future getAllListRepo() async{
    return await apiClient.getAllTicketListApi();
  }

  Future getOpenListRepo() async{
    return await apiClient.getOpenTicketListApi();
  }

  Future getAnsweredListRepo(String ticketId) async{
    return await apiClient.getAnsweredThreadsApi(ticketId);
  }

  Future getResolvedListRepo(String ticketId) async{
    return await apiClient.getResolvedThreadsApi(ticketId);
  }

  Future getClosedListRepo(String ticketId) async{
    return await apiClient.getClosedThreadsApi(ticketId);
  }

  Future getGroupListRepo() async{
    return await apiClient.getGroupListApi();
  }

  Future uvDeskTicketRaiseRepo(Map data, {List<File>? attachments}) async{
    return await apiClient.uvDeskTicketRaiseApi(data,attachments: attachments);
  }

  Future uvDeskTicketThreadsRepo(String ticketId) async{
    return await apiClient.getTicketThreadsApi(ticketId);
  }

  Future uvDeskSendReplyRepo(String ticketId, Map data, {List<File>? attachments}) async{
    return await apiClient.uvDeskSendReplyApi(ticketId, data, attachments: attachments);
  }

  Future uvDeskCancelledRepo(String property, String value,String threadId) async{
    return await apiClient.uvDeskCancelledApi(property, value,threadId);
  }

  Future uvDeskTransferToDoctorRepo(String property,String value,String threadId) async{
    return await apiClient.uvDeskTransferToDoctorApi(property,value,threadId);
  }

  Future uvDeskReassignRepo(String agentId,String threadId) async{
    return await apiClient.uvDeskReassignApi(agentId,threadId);
  }

  Future getDoctorDetailsRepo(String email) async{
    return await apiClient.getDoctorDetailsApi(email);
  }

  // Future getTicketDetailsByIdRepo(String id) async{
  //   return await apiClient.getTicketDetailsApi(id);
  // }
  //
  // Future createTicketRepo(Map data, {List<MultipartFile>? attachments}) async{
  //   return await apiClient.createTicketApi(data, attachments: attachments);
  // }
  //
  // Future getTicketsByCustomerIdRepo(String customerId) async{
  //   return await apiClient.getTicketListByCustomerIdApi(customerId);
  // }
}