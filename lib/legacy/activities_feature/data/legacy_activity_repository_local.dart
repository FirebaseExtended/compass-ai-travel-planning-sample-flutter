// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
