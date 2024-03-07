import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pp_22/helpers/email_helper.dart';
import 'package:pp_22/helpers/text_helper.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/routes/routes.dart';

class AgreementView extends StatefulWidget {
  final AgreementViewArguments arguments;
  const AgreementView({super.key, required this.arguments});

  factory AgreementView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as AgreementViewArguments;
    return AgreementView(arguments: arguments);
  }

  @override
  State<AgreementView> createState() => _AgreementViewState();
}

class _AgreementViewState extends State<AgreementView> {

  AgreementType get _agreementType => widget.arguments.agreementType;

  bool get _usePrivacyAgreement => widget.arguments.usePrivacyAgreement;

  bool get _isFromOnboarding => widget.arguments.isFromOnboarding;

  String get _agreementText => _agreementType == AgreementType.privacy
      ? TextHelper.privacy
      : TextHelper.terms;

  String get _title => _agreementType == AgreementType.privacy
      ? 'Privacy Policy'
      : 'Terms Of Use';

  void _accept() {
    if (_isFromOnboarding) {
      Navigator.of(context).pushReplacementNamed(
        RouteNames.paywall,
        arguments: PaywallViewArguments(isFromOnboarding: true),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.pages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_usePrivacyAgreement)
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.displayLarge,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 30),
                        Text(
                          _title,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        AppCloseButton()
                      ],
                    ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 70),
                        physics: const BouncingScrollPhysics(),
                        child: MarkdownBody(
                          styleSheet: MarkdownStyleSheet(
                            h1: Theme.of(context).textTheme.displayMedium,
                            h2: Theme.of(context).textTheme.headlineMedium,
                            h3: Theme.of(context).textTheme.displaySmall,
                            h4: Theme.of(context).textTheme.headlineSmall,
                          ),
                          data: _agreementText,
                          onTapLink: (text, href, title) =>
                              EmailHelper.launchEmailSubmission(
                            toEmail: text,
                            subject: '',
                            body: '',
                            errorCallback: () {},
                            doneCallback: () {},
                          ),
                          selectable: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_usePrivacyAgreement)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 60,
                    child: AppButton(
                      label: 'Accept app privacy',
                      onPressed: _accept,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

enum AgreementType {
  privacy,
  terms,
}
