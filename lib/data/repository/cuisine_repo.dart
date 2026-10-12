import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:foodnanny/data/model/quisine_model.dart';
import 'package:foodnanny/data/server/server.dart';
import 'package:foodnanny/utils/api_list.dart';

import '../../app/features/home/parser/home_parser.dart';

class QuisinRepo {
  Future<Either<String, QuisineModel>> getQuisine() async {
    try {
      final response = await Server().getRequestWithToken(
        endPoint: ApiList.quisine,
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        final parsedModel = await compute(parseQuisine, data);
        return Right(parsedModel);
      } else {
        return Left(response.data);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
