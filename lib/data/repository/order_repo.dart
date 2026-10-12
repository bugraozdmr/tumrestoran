import 'package:dartz/dartz.dart';
import 'package:foodnanny/utils/api_list.dart';
import '../model/active_order_history_model.dart';
import '../model/order_details_model.dart';
import '../model/previous_order_history_model.dart';
import '../server/server.dart';

class OrderRepo {
  static Server server = Server();

  static OrderDetailsModel orderDetailsModel = OrderDetailsModel();

  static Future<Either<String, ActiveOrderHistoryModel>>
  getActiveOrders() async {
    try {
      final response = await server.getRequestWithToken(
        endPoint: ApiList.activeOrders,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        return Right(ActiveOrderHistoryModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, ActiveOrderHistoryModel>>
  getCurrentlyActiveOrder() async {
    try {
      final response = await server.getRequestWithToken(
        endPoint: ApiList.currentActiveOrder,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        return Right(ActiveOrderHistoryModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, PreviousOrderHistoryModel>>
  getPreviousOrders() async {
    try {
      final response = await server.getRequestWithToken(
        endPoint: ApiList.previousOrders(),
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        return Right(PreviousOrderHistoryModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  static Future<Either<String, OrderDetailsModel>> getOrderDetails({
    required String id,
  }) async {
    final response = await server.getRequestWithToken(
      endPoint: ApiList.orderDetails(id: id.toString()),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return Right(OrderDetailsModel.fromJson(data));
    } else {
      return Left(response.data['message']);
    }
  }
}
