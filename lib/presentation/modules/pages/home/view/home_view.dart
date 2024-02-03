import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/presentation/components/app_button.dart';
import 'package:pp_22_copy/routes/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              AppButtonWithWidget(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.search),
                child: Row(
                  children: [
                    Assets.icons.search
                        .svg(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Search for coins',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 34),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).colorScheme.surface,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                ),
                child: Column(
                  children: [
                    Assets.images.coinsHome.image(height: 270),
                    Text(
                      'Find your coin’s true worth',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'Start indentifying with expertise',
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                              ),
                    ),
                    SizedBox(height: 26),
                    AppButton(
                      label: 'Identify coin',
                      onPressed: () =>
                          Navigator.of(context).pushNamed(RouteNames.camera),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
