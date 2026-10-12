import 'package:dartz/dartz.dart';
import 'package:tumrestoran/data/model/tip_model.dart';
import 'package:tumrestoran/data/server/server.dart';
import 'package:tumrestoran/utils/api_list.dart';

class CheckoutRepo {
  Future<Either<String, TipModel>> riderTips() async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.riderTip,
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(TipModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
