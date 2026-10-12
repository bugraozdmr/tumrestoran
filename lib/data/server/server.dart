import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foodnanny/utils/api_list.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

var token = box.read('token');

class Server {
  final dio = Dio();

  header() {
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json, text/plain, */*",
      "Access-Control-Allow-Origin": "*",
      "x-api-key": ApiList.licenseKey,
      "x-localization": box.read('languageCode').toString(),
    };

    return headers;
  }

  headerWithToken() {
    var token = box.read('token');
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json, text/plain, */*",
      "Access-Control-Allow-Origin": "*",
      "x-api-key": ApiList.licenseKey,
      "x-localization": box.read('languageCode').toString(),
      'Authorization': 'Bearer $token',
    };

    return headers;
  }

  postRequest({required String endpoint, Map<String, dynamic>? body}) async {
    try {
      var response = await dio.post(
        endpoint,
        options: Options(
          headers: header(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: body,
      );
      return response;
    } catch (e) {
      final errorMessage = '$e';
      return errorMessage;
    }
  }

  postRequestWithToken({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      var response = await dio.post(
        endpoint,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
        data: body,
      );
      return response;
    } catch (e) {
      final errorMessage = '$e';
      return errorMessage;
    }
  }

  getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: header(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  getRequestWithToken({required String endPoint}) async {
    try {
      final response = await dio.get(
        endPoint,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      print('==== API REQUEST ====');
      print('ENDPOINT: $endPoint');
      print('RESPONSE CODE: ${response.statusCode}');
      print('RESPONSE DATA: ${response.data}');
      print('=====================');
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  putRequest({
    required String endPoint,
    required Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.put(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  putRequestWithToken({
    required String endPoint,
    required Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  deleteRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  multipartRequest(endPoint, filepath) async {
    HttpClient client = HttpClient();
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endPoint!))
        ..headers.addAll(headerWithToken())
        ..files.add(await http.MultipartFile.fromPath('image', filepath!));
      return await request.send();
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }
}
