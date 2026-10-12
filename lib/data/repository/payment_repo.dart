import 'package:dartz/dartz.dart';
import 'package:foodnanny/data/model/payment_model.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:foodnanny/utils/api_list.dart';

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
