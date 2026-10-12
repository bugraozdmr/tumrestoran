import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/payment_model.dart';
import 'package:tumrestoran/data/server/server.dart';
import 'package:tumrestoran/utils/api_list.dart';

class PaymentRepo {
  Future<Either<String, PaymentModel>> getPaymentGateways() async {
    try {
      final response =
          await Server().getRequestWithToken(endPoint: ApiList.paymentGateway);
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(PaymentModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
