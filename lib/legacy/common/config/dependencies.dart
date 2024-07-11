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

import '../../results/business/usecases/search_destination_usecase.dart';
import '../../results/data/destination_repository_local.dart';
import '../../results/presentation/results_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Configure dependencies as a list of Providers
List<SingleChildWidget> get providers {
  // These dependencies don't need to be in the widget tree (yet?)
  final destinationRepository = DestinationRepositoryLocal();
  // Configure usecase to use the local data repository implementation
  final searchDestinationUsecase = SearchDestinationUsecase(
    repository: destinationRepository,
  );

  // List of Providers
  return [
    // ViewModels are injected into Views using Provider
    ChangeNotifierProvider(
      create: (_) => ResultsViewModel(
        searchDestinationUsecase: searchDestinationUsecase,
      ),
      // create this ViewModel only when needed
      lazy: true,
    ),
  ];
}
