import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:tumrestoran/app/features/restaurant_details/parser/restuarant_details_parser.dart';
import 'package:tumrestoran/data/model/item_details_model.dart';
import 'package:tumrestoran/data/model/restaurant_details.dart';
import 'package:tumrestoran/data/model/restaurant_offer_model.dart';
import 'package:tumrestoran/data/model/search_menu_model.dart';
import '../../utils/api_list.dart';
import '../model/item_category_model.dart';
import '../server/server.dart';

class RestuarantDetailsRepo {
  Future<Either<String, RestaurantDetailsModel>> getRestuarantDetails({
    required String slug,
  }) async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.restaurantDetails(slug: slug),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final parsedDetails = await compute(parseRestaurantDetails, data);
        return Right(parsedDetails);
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ItemCategoryDetailsModel>> getItemCategoryDetails({
    required String slug,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.itemCategoryDetails(slug: slug),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        return Right(ItemCategoryDetailsModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ItemDetailsModel>> getItemDetails({
    required String slug,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.itemDetails(slug: slug),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(ItemDetailsModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, RestaurantOfferModel>> getOfferForRestaurant({
    required String restaurantId,
    required String lat,
    required String long,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.offerForRestaurant(
          restaurantId: restaurantId,
          lat: lat,
          long: long,
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        return Right(RestaurantOfferModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SearchMenuModel>> searchMenu({
    required String restuarantName,
    required String slug,
    required String name,
  }) async {
    try {
      final response = await Server().getRequest(
        endPoint: ApiList.searchMenu(restaurantName: restuarantName),
        queryParameters: {"slug": slug, "name": name},
      );

      if (response.statusCode == 200) {
        debugPrint("Search menu = ${response.data}");
        Map<String, dynamic> data = response.data;
        return Right(SearchMenuModel.fromJson(data));
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
