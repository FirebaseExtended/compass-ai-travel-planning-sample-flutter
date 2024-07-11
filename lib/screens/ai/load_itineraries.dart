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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripedia/screens/ai/dreaming.dart';
import 'package:tripedia/screens/ai/itineraries.dart';
import '../../view_models/intineraries_viewmodel.dart';

class LoadItinerariesScreen extends StatelessWidget {
  const LoadItinerariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var itineraries = context.watch<ItinerariesViewModel>().itineraries;

    if (itineraries == null) {
      return const DreamingScreen();
    } else {
      return const Itineraries();
    }
  }
}
