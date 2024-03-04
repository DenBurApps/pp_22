import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/presentation/components/app_close_button.dart';
import 'package:pp_22_copy/presentation/modules/agreement_view.dart';
import 'package:pp_22_copy/routes/routes.dart';

import '../components/app_button.dart';

class PayWallView extends StatefulWidget {
  final PaywallViewArguments arguments;
  const PayWallView({
    super.key,
    required this.arguments,
  });

  @override
  State<PayWallView> createState() => _PayWallViewState();

  factory PayWallView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as PaywallViewArguments;
    return PayWallView(arguments: arguments);
  }
}

class _PayWallViewState extends State<PayWallView> {
  bool get _isFromOnboarding => widget.arguments.isFromOnboarding;

  void _showOnErrorDialog(String error) => showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: Navigator.of(context).pop,
              child: const Text('OK'),
            )
          ],
        ),
      );

  void _close() {
    if (_isFromOnboarding) {
      Navigator.of(context).pushReplacementNamed(RouteNames.pages);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _makePurchase() async {}

  Future<void> _restorePurcahse() async {}

  void _onDone() {
    if (_isFromOnboarding) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(RouteNames.pages);
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppCloseButton(
        onPressed: _close,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.paywall.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Get premium",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFECEDF2),
                  boxShadow: [
                    BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                  color: Colors.grey.withOpacity(0.4),
                )
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _InfoRow(
                      richWord: 'Unlimited',
                      otherWords: 'Coins Scan & Identify',
                    ),
                    const SizedBox(height: 21),
                    _InfoRow(
                      richWord: 'Detailed',
                      otherWords: 'information about coins',
                    ),
                    const SizedBox(height: 21),
                    _InfoRow(
                      richWord: 'Organize',
                      otherWords: ' your collection',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              AppButton(
                label: 'Continue',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Text(
                'Get Premium access just \$3.99 / week',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PayWallBottomButton(
                    buttonText: 'Privacy Policy',
                    onPressed: () => Navigator.of(context).pushNamed(
                      RouteNames.agreement,
                      arguments: AgreementViewArguments(
                        agreementType: AgreementType.privacy,
                      ),
                    ),
                  ),
                  _PayWallBottomButton(
                    buttonText: 'Terms of Use',
                    onPressed: () => Navigator.of(context).pushNamed(
                      RouteNames.agreement,
                      arguments: AgreementViewArguments(
                        agreementType: AgreementType.terms,
                      ),
                    ),
                  ),
                  _PayWallBottomButton(
                    buttonText: 'Restore Purchase',
                    onPressed: _restorePurcahse,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PayWallBottomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  const _PayWallBottomButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String richWord;
  final String otherWords;

  const _InfoRow({
    required this.richWord,
    required this.otherWords,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$richWord ',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              TextSpan(
                  text: otherWords,
                  style: Theme.of(context).textTheme.displaySmall),
            ],
          ),
        )
      ],
    );
  }
}
