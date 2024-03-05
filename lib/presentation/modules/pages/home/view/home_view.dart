import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22/generated/assets.gen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              CupertinoButton(
                padding: EdgeInsets.symmetric(horizontal: 16),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary)),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle),
                        child: Assets.icons.search.svg(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Search for coins',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.5),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Find your coin’s true worth',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              SizedBox(height: 9),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Start indentifying with expertise',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Assets.images.hand.image(
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
