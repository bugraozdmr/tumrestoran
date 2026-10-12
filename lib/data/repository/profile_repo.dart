import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/profile_model.dart';
import '../../utils/api_list.dart';
import '../server/server.dart';

class ProfileRepo {
  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.profile,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(ProfileModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ProfileModel>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String countryCode,
  }) async {
    try {
      final response = await Server().putRequest(
        endPoint: ApiList.profile,
        queryParameters: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "country_code": countryCode,
        },
      );
      if (response.statusCode == 200) {
        final data = response.body;
        return Right(ProfileModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
