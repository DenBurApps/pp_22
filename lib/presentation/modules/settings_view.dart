import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pp_22_copy/generated/assets.gen.dart';
import 'package:pp_22_copy/helpers/dialog_helper.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/presentation/components/app_back_button.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';
import 'package:pp_22_copy/presentation/modules/agreement_view.dart';
import 'package:pp_22_copy/routes/routes.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<void> _rate() async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  }

  void _showAppVersionDialog(BuildContext context) =>
      DialogHelper.showAppVersionDialog(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppBackButton(),
                  SizedBox(width: 9),
                  Expanded(child: AppBanner(label: 'Settings')),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Information',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 13),
              _SettingsButton(
                icon: Assets.icons.privacy,
                title: 'Privacy Policy',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.agreement,
                  arguments: AgreementViewArguments(
                    agreementType: AgreementType.privacy,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _SettingsButton(
                icon: Assets.icons.terms,
                title: 'Terms of Use',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.agreement,
                  arguments: AgreementViewArguments(
                    agreementType: AgreementType.terms,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Contact us',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 13),
              _SettingsButton(
                icon: Assets.icons.rateUs,
                title: 'Rate us',
                onPressed: _rate,
              ),
              const SizedBox(height: 10),
              _SettingsButton(
                icon: Assets.icons.aboutUs,
                title: 'Contact with support',
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.contactSupport),
              ),
              const SizedBox(height: 10),
              _SettingsButton(
                icon: Assets.icons.version,
                title: 'Version',
                onPressed: () => _showAppVersionDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final SvgGenImage icon;
  final VoidCallback? onPressed;
  final String title;
  const _SettingsButton({
    required this.icon,
    this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(13)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon.svg(color: Theme.of(context).colorScheme.onSecondary),
            const SizedBox(width: 7),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSecondary,
            )
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
