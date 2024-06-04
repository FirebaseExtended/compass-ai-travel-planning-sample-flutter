import 'result_card.dart';
import 'results_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../activities_feature/models/activity.dart';
import '../../../common/utilties.dart';
import '../../../common/services/navigation.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var startDate =
        prettyDate(context.read<TravelPlan>().query!.dates.start.toString());
    var endDate =
        prettyDate(context.read<TravelPlan>().query!.dates.end.toString());
    var numPeople = context.read<TravelPlan>().query!.numPeople;
    var isLarge = MediaQuery.of(context).size.width > 1024;
    var textStyle = isLarge
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.titleSmall;

    return Consumer<ResultsViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primaryFixedDim,
            ),
            onPressed: () {
              context.read<TravelPlan>().clearQuery();
              Navigator.pop(context);
            },
          ),
          title: Text(
            '${viewModel.filters} • $startDate – $endDate • $numPeople ${numPeople == 1 ? 'person' : 'people'}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textStyle?.fontSize,
              fontWeight: FontWeight.w400,
              height: 0,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  style: ButtonStyle(
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.grey[300]!),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () => goToSplashScreen(context),
                  icon: const Icon(
                    Icons.home_outlined,
                  ),
                )),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: Consumer<ResultsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _Grid(viewModel: viewModel),
            );
          },
        ),
      );
    });
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.viewModel,
  });

  final ResultsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    var isSmall = MediaQuery.sizeOf(context).width < 800;
    var childAspectRatio = isSmall ? 182 / 222 : 1.0;
    if (isSmall) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          if (index < viewModel.destinations.length) {
            return ResultCard(
              isSmall: isSmall,
              key: ValueKey(viewModel.destinations[index].ref),
              destination: viewModel.destinations[index],
            );
          }
          return null;
        },
      );
    } else {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: childAspectRatio,
            maxCrossAxisExtent: 600,
          ),
          itemBuilder: (context, index) {
            if (index < viewModel.destinations.length) {
              return ResultCard(
                isSmall: isSmall,
                key: ValueKey(viewModel.destinations[index].ref),
                destination: viewModel.destinations[index],
              );
            }
            return null;
          });
    }
  }
}
