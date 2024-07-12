import 'dart:convert';

import '../../common/utils/result.dart';
import '../models/activity.dart';
import 'legacy_activity_repository.dart';

import 'package:flutter/services.dart' show rootBundle;

class ActivityRepositoryLocal implements LegacyActivityRepository {
  /// Obtain list of Activities from local assets
  @override
  Future<Result<List<LegacyActivity>>> getActivities() async {
    try {
      final localData = await _loadAsset();
      final list = _parse(localData);
      return Result.ok(list);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/activities.json');
  }

  List<LegacyActivity> _parse(String localData) {
    final parsed = (jsonDecode(localData) as List).cast<Map<String, dynamic>>();

    return parsed
        .map<LegacyActivity>((json) => LegacyActivity.fromJson(json))
        .toList();
  }
}
