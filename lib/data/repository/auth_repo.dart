import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/login_model.dart';
import 'package:tumrestoran/data/server/server.dart';
import 'package:tumrestoran/utils/api_list.dart';

class AuthRepo {
  final Server _server = Server();
  login({
    required String email,
    required String password,
  }) async {
    final response = await _server.postRequest(
      endpoint: ApiList.login,
      body: {
        "email": email,
        "password": password,
      },
    );
    return response;
  }

  Future<Either<String, LoginModel>> signup({
    required String email,
    required String password,
  }) async {
    final response = await _server.postRequest(
      endpoint: ApiList.login,
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 201) {
      final data = response.data;
      return Right(LoginModel.fromJson(data));
    } else {
      return const Left("Invalid email or password");
    }
  }

  logout() async {
    var response = await _server.postRequestWithToken(endpoint: ApiList.logout);
    return response;
  }
}
