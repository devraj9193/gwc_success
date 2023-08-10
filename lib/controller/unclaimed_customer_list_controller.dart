import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/claimed_customer_model/claimed_customer_list_model.dart';
import '../model/claimed_customer_model/unclaimed_customer_list_model.dart';
import '../utils/gwc_api.dart';

class UnClaimedCustomerListController extends GetxController {
  UnClaimedCustomerList? unClaimedCustomerList;

  @override
  void onInit() {
    super.onInit();
    fetchNotClaimedCustomerList();
    fetchClaimedCustomerList();
  }

  Future<List<NotClaimedCustomer>?> fetchNotClaimedCustomerList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
    await http.get(Uri.parse(GwcApi.unClaimedCustomerListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    print("Unclaimed Customer List url: ${GwcApi.unClaimedCustomerListApiUrl}");
    print("Unclaimed Customer List response:: ${response.body}");

    if (response.statusCode == 200) {
      UnClaimedCustomerList jsonData = unClaimedCustomerListFromJson(response.body);
      List<NotClaimedCustomer>? arrData = jsonData.notClaimedCustomer;
      print("status: ${arrData?[0].name}");
      return arrData;
    } else {
      throw Exception();
    }
  }

  Future<List<ClaimedCustomer>?> fetchClaimedCustomerList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    final response =
    await http.get(Uri.parse(GwcApi.claimedCustomerListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    print("Claimed Customer List url: ${GwcApi.claimedCustomerListApiUrl}");
    print("Claimed Customer List response:: ${response.body}");

    if (response.statusCode == 200) {
      ClaimedCustomerListModel jsonData = claimedCustomerListModelFromJson(response.body);
      List<ClaimedCustomer>? arrData = jsonData.data;
      return arrData;
    } else {
      throw Exception();
    }
  }
}
