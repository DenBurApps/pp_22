import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/routes/routes.dart';
import 'package:pp_22_copy/services/database/database_keys.dart';
import 'package:pp_22_copy/services/database/database_service.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _databaseService = GetIt.instance<DatabaseService>();

  var _currentStep = 0;

  final _steps = [
    _OnboardingStep(
      background: Assets.images.onbording1,
      description: 'Quick coin scanning\nand identifying',
    ),
    _OnboardingStep(
      background: Assets.images.onbording2,
      description: 'Huge library of coins\nfrom different times',
    ),
    _OnboardingStep(
      background: Assets.images.onbording3,
      description: 'Collect your own\nexclusive collection',
    ),
  ];

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _databaseService.put(DatabaseKeys.seenOnboarding, true);
  }

  void _progress() {
    if (_currentStep == 2) {
      Navigator.of(context).pushReplacementNamed(RouteNames.pages);
    } else {
      setState(() => _currentStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _steps[_currentStep].background.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _steps[_currentStep].description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Theme.of(context).colorScheme.surface),
            ),
            SizedBox(height: 60),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Theme.of(context).colorScheme.surface),
                ),
                child: Assets.icons.forward.svg(),
              ),
              onPressed: _progress,
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final AssetGenImage background;
  final String description;

  const _OnboardingStep({
    required this.background,
    required this.description,
  });
}
