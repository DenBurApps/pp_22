import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/helpers/dialog_helper.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/presentation/modules/agreement_view.dart';
import 'package:pp_22/routes/routes.dart';
import 'package:pp_22/services/database/database_keys.dart';
import 'package:pp_22/services/database/database_service.dart';

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
      background: Assets.images.onboarding1,
      description: 'Find the coins',
      icon: Assets.icons.onboardingSearch,
    ),
    _OnboardingStep(
      background: Assets.images.onboarding2,
      description: 'Recognize their value',
    ),
    _OnboardingStep(
      background: Assets.images.onboarding3,
      description: 'Build your collections',
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
      _close();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _close() {
    final acceptedPrivacy =
        _databaseService.get(DatabaseKeys.acceptedPrivacy) ?? false;
    if (!acceptedPrivacy) {
      DialogHelper.showPrivacyAgreementDialog(
        context,
        yes: () => Navigator.of(context).pushReplacementNamed(
          RouteNames.agreement,
          arguments: AgreementViewArguments(
            agreementType: AgreementType.privacy,
            usePrivacyAgreement: true,
            isFromOnboarding: true,
          ),
        ),
        no: () => Navigator.of(context).pushReplacementNamed(
          RouteNames.paywall,
          arguments: PaywallViewArguments(isFromOnboarding: true),
        ),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(
        RouteNames.paywall,
        arguments: PaywallViewArguments(isFromOnboarding: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppCloseButton(
        onPressed: _close, 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: GestureDetector(
        onTap: _progress,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _steps[_currentStep].background.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _steps[_currentStep].description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 33,
                          ),
                    ),
                    if (_steps[_currentStep].icon != null) ...[
                      SizedBox(width: 30),
                      _steps[_currentStep].icon!.svg(),
                    ]
                  ],
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => _TextStep(
                        value: index + 1, isActive: index == _currentStep),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextStep extends StatelessWidget {
  final int value;
  final bool isActive;
  const _TextStep({required this.value, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: Text(
        value.toString(),
        textAlign: TextAlign.center,
        style: isActive
            ? Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary)
            : Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
      ),
    );
  }
}

class _OnboardingStep {
  final AssetGenImage background;
  final String description;
  final SvgGenImage? icon;

  const _OnboardingStep({
    required this.background,
    required this.description,
    this.icon,
  });
}
