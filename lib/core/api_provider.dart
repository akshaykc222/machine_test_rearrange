import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:machine_test_rearrange/core/pretty_printer.dart';

import '../rearrange/data/data_sources/app_remote_routes.dart';
import 'custom_exception.dart';

class ApiProvider {
  late Dio _dio;

  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          return true;
        },
        followRedirects: false,
        headers: {
          // "access-control-allow-origin": "*",
          // "Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Credentials": false,
          // 'Content-Type': 'application/json'
        },
        baseUrl: AppRemoteRoutes.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    if (!kIsWeb) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }
  // addToken() async {
  //   GetStorage storage = GetStorage();
  //   String? token = storage.read(
  //     LocalStorageNames.token,
  //   );
  //   debugPrint("Adding token : $token");
  //   if (token != null) {
  //     _dio.options.headers.addAll({'Authorization': 'Token $token'});
  //   }
  // }

  Future<Map<String, dynamic>> get(String endPoint) async {
    try {
      // addToken();
      prettyPrint(_dio.options.headers.toString());
      final Response response = await _dio.get(
        endPoint,
      );
      prettyPrint("request url : ${response.realUri}");
      var responseData = classifyResponse(response);

      return responseData;
    } on DioError catch (err) {
      prettyPrint(err.toString(), type: PrettyPrinterTypes.error);
      throw BadRequestException();
    }
  }

  Future<Map<String, dynamic>> delete(String endPoint) async {
    try {
      // addToken();
      prettyPrint(_dio.options.headers.toString());
      final Response response = await _dio.delete(
        endPoint,
      );
      prettyPrint("getting response${response.realUri}");
      final Map<String, dynamic> responseData = classifyResponse(response);
      return responseData;
    } on DioError catch (err) {
      prettyPrint(err.toString(), type: PrettyPrinterTypes.error);
      return {};
    }
  }

  Future<Map<String, dynamic>> post(
    String endPoint,
    dynamic body,
  ) async {
    prettyPrint("on post call$body");
    try {
      prettyPrint("starting dio");

      // addToken();
      // prettyPrint(_dio.options.)
      final Response response = await _dio.post(
        endPoint,
        data: body,
      );

      prettyPrint(
          "getting response${response.realUri} ${_dio.options.headers}");
      final Map<String, dynamic> responseData = classifyResponse(response);
      prettyPrint(responseData.toString());
      return responseData;
    } on DioError catch (err) {
      prettyPrint(err.toString());
      throw FetchDataException("internetError");
    }
  }

  Future<Map<String, dynamic>> put(String endPoint, dynamic body) async {
    prettyPrint("on post call");
    try {
      // addToken();
      final Response response = await _dio.put(
        endPoint,
        data: body,
      );

      final Map<String, dynamic> responseData = classifyResponse(response);

      return responseData;
    } on DioError catch (err) {
      prettyPrint(err.message, type: PrettyPrinterTypes.error);
      throw FetchDataException("internetError");
    }
  }

  Future<Map<String, dynamic>> patch(String endPoint, dynamic body) async {
    prettyPrint("on post call");
    try {
      // addToken();
      final Response response = await _dio.patch(
        endPoint,
        data: body,
      );

      final Map<String, dynamic> responseData = classifyResponse(response);

      return responseData;
    } on DioError catch (err) {
      prettyPrint(err.message, type: PrettyPrinterTypes.error);
      throw FetchDataException("internetError");
    }
  }

  // Future<Uint8List> download({required String imageUrl}) async {
  //   final tempStorage = await getTemporaryDirectory();
  //   final data = await _dio.download(imageUrl, tempStorage.path);
  //   final d = data.data;
  // }

  Map<String, dynamic> classifyResponse(Response response) {
    print(response);
    // try {

    dynamic responseData = response.data;
    String errorMsg = "";
    try {
      // errorMsg=responseData["error"][""]
      var error = responseData["errors"];
      var allErrors = error!.map((item) => item["message"]);
      String errorString = "";
      for (var i in allErrors) {
        errorString = "$errorString$i,";
      }
    } catch (e) {
      errorMsg = responseData.toString();
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        if (responseData is List) {
          return {'data': responseData};
        }
        return responseData;
      case 400:
        errorMsg = "";
        responseData.forEach((key, value) {
          try {
            print("run time type ${value.runtimeType.toString()}");
            if (value is List<dynamic>) {
              for (var element in value) {
                errorMsg = "$errorMsg\u2022$element\n\n";
              }
            } else if (value is String) {
              errorMsg = "$errorMsg\u2022$value\n\n";
            }
          } catch (e) {
            print(e);
            errorMsg = "";
          }
        });
        throw BadRequestException(errorMsg);
      case 404:
        throw BadRequestException(errorMsg);
      case 401:
        throw UnauthorisedException(errorMsg);
      case 403:
        throw BadRequestException(errorMsg);
      case 409:
        throw DeleteConflictException(errorMsg);
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
    // } catch (e) {
    //   throw BadRequestException("something went  wrong");
    // }
  }
}
