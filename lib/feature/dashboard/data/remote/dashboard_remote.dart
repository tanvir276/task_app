import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:task_app/constant/api_constants.dart';
import 'package:task_app/exceptions/exceptions.dart';
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:task_app/header_provider/header_provider.dart';

abstract class DashboardRemote {
  Future<DashboardResponse> dashboard();
}

class DashboardRemoteImpl implements DashboardRemote {
  var dashboardEndpoint = ApiConstants.dashboardUrl;
  final HeaderProvider _apiHeaderProvider;
  DashboardRemoteImpl(this._apiHeaderProvider);

  @override
  Future<DashboardResponse> dashboard() async {
    DashboardResponse res;
    final headers = _apiHeaderProvider();
    final response =
        await http.get(Uri.parse(dashboardEndpoint), headers: headers);
    log(json.encode(response.body));
    if (response.statusCode == 200) {
        print("in 200");

      final Map<String, dynamic> map = jsonDecode(response.body);
      final success = map['success'];
      if (success == true) {
        res = dashboardResponseFromJson(response.body);
        return res;
      } else {
        throw ServerException(
          message: "Try again later",
          statusCode: response.statusCode,
        );
      }
    } else {
      throw ServerException(
        message: "Internal server error, try again later",
        statusCode: response.statusCode,
      );
    }
  }
}
