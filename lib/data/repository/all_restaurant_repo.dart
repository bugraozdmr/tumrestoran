import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:foodnanny/app/features/home/model/single_offer_model.dart'
    as single;
import 'package:foodnanny/app/features/home/parser/home_parser.dart';
import 'package:foodnanny/data/model/campaign_model.dart';
import 'package:foodnanny/data/model/restuarant_model.dart';
import '../../app/features/home/model/find_offer_model.dart';
import '../../app/features/home/model/single_check_offer_model.dart';
import '../../utils/api_list.dart';
import '../server/server.dart';

class AllRestuarantRepo {
  Future<Either<String, RestaurantModel>> getAllRestuarantByLatLong({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.allRestaurantByLatLong(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final parsedModel = await compute(parseAllRestaurant, data);
        return Right(parsedModel);
      } else {
        return Left(response.data.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, RestaurantModel>> getAllRestuarantBySearch({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String query,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.allRestaurantBySearch(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
          query: query,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(RestaurantModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, RestaurantModel>> getRestuarantByQuisineId({
    required String lat,
    required String long,
    required String deliveryOrderType,
    required String quisineId,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.restaurantByCuisine(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
          cuisineId: quisineId,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(RestaurantModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CampaingModel>> getCampaign({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.campaing(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(CampaingModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CampaingModel>> getOfferBanner({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.offer(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(CampaingModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Campaign>> showCampaign({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.showCampaign(
          slug: slug,
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        return Right(Campaign.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Campaign>> showOffer({
    required String slug,
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.showOffer(
          slug: slug,
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        return Right(Campaign.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, single.SingleOfferModel>> getSingleOfferRestaurants({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.singleOffer(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        final parsedModel = await compute(parseSingleOffer, data);

        return Right(parsedModel);
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CheckSingleOfferModel>> checkSingleOfferRestaurant({
    required String lat,
    required String long,
    required String restaurantId,
  }) async {
    try {
      final response = await Server().postRequestWithToken(
        endpoint: ApiList.checkSingleOffer(restaurantId: restaurantId),
        body: {"id": restaurantId, "latitude": lat, "longitude": long},
      );

      final data = response.data['data'];

      if (data != null && data is Map && data.isNotEmpty) {
        return Right(CheckSingleOfferModel.fromJson(response.data));
      } else {
        return Left(response.data['data'].toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, FindOfferModel>> findOffer({
    required String lat,
    required String long,
    required String deliveryOrderType,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.findOffer(
          lat: lat,
          long: long,
          deliveryOrderType: deliveryOrderType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Right(FindOfferModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
