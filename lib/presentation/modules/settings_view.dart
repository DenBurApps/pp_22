import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pp_22/generated/assets.gen.dart';
import 'package:pp_22/helpers/dialog_helper.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/presentation/modules/agreement_view.dart';
import 'package:pp_22/presentation/modules/pages/collections/views/collections_view.dart';
import 'package:pp_22/routes/routes.dart';

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
              Align(
                child: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Information',
                style: Theme.of(context).textTheme.displayMedium,
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
              const SizedBox(height: 35),
              Text(
                'My subscription',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 13),
              _SettingsButton(
                icon: Assets.icons.subscription,
                title: 'Subscription status',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.subscription,
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'My collections',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 13),
              _SettingsButton(
                icon: Assets.icons.settingsCollections,
                title: 'My collections',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CollectionsView(
                      isFromSettings: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Text(
                'Contact us',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 13),
              _SettingsButton(
                icon: Assets.icons.rateUs,
                title: 'Rate us',
                onPressed: _rate,
              ),
              const SizedBox(height: 10),
              _SettingsButton(
                icon: Assets.icons.contactDeveloper,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon.svg(color: Theme.of(context).colorScheme.onBackground),
          const SizedBox(width: 7),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onBackground,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
