import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pp_22_copy/helpers/email_helper.dart';
import 'package:pp_22_copy/helpers/text_helper.dart';
import 'package:pp_22_copy/models/arguments.dart';
import 'package:pp_22_copy/presentation/components/app_back_button.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';

class AgreementView extends StatelessWidget {
  final AgreementViewArguments arguments;
  const AgreementView({super.key, required this.arguments});

  factory AgreementView.create(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as AgreementViewArguments;
    return AgreementView(arguments: arguments);
  }

  AgreementType get _agreementType => arguments.agreementType;

  String get _agreementText => _agreementType == AgreementType.privacy
      ? TextHelper.privacy
      : TextHelper.terms;

  String get _title => _agreementType == AgreementType.privacy
      ? 'Privacy Policy'
      : 'Terms Of Use';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                children: [
                  AppBackButton(),
                  SizedBox(width: 9),
                  Expanded(child: AppBanner(label: _title)),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: MarkdownBody(
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
          ],
        ),
      ),
    );
  }
}

enum AgreementType {
  privacy,
  terms,
}
