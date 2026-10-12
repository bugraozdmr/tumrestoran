import 'package:dartz/dartz.dart';
import 'package:foodnanny/data/model/delivery_time_model.dart';

import '../../utils/api_list.dart';
import '../server/server.dart';

class DeliveryTimeRepo {
  Future<Either<String, DeliveryTimeModel>> getTodaysDeliveryTime({
    required int restaurantId,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.todayTime(restaurantId: restaurantId),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(DeliveryTimeModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, DeliveryTimeModel>> getTomorrowDeliveryTime({
    required int restaurantId,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.tomorrowTime(restaurantId: restaurantId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(DeliveryTimeModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
