import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/address_model.dart';
import '../../utils/api_list.dart';
import '../server/server.dart';

class AddressRepo {
  Future<Either<String, AddressModel>> getAddress() async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.address,
      );
      if (response.statusCode == 200) {
        final data = response.data;

        return Right(AddressModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future addNewAddress({
    required String label,
    required double latitude,
    required double longitude,
    required String address,
    String? apartment,
  }) async {
    final response = await Server().postRequestWithToken(
      endpoint: ApiList.address,
      body: {
        "label": label,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "apartment": apartment,
      },
    );

    return response;
  }

  Future deleteAddress({required int id}) async {
    final response = await Server().deleteRequest(
      endPoint: ApiList.deleteAddress(id: id),
    );
    return response;
  }

  Future editAddress({
    required int id,
    required String label,
    required double latitude,
    required double longitude,
    required String address,
    String? apartment,
  }) async {
    final response = await Server().putRequest(
      endPoint: ApiList.editAddress(id: id),
      queryParameters: {
        "label": label,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "apartment": apartment,
      },
    );
    return response;
  }
}
