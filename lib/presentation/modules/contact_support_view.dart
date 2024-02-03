import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_22_copy/helpers/email_helper.dart';
import 'package:pp_22_copy/presentation/components/app_back_button.dart';
import 'package:pp_22_copy/presentation/components/app_banner.dart';
import 'package:pp_22_copy/presentation/components/app_button.dart';

class ContactSupportView extends StatefulWidget {
  const ContactSupportView({super.key});

  @override
  State<ContactSupportView> createState() => _ContactSupportViewState();
}

class _ContactSupportViewState extends State<ContactSupportView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
        toEmail: 'ksuvei@finconte.site',
        subject: _subjectController.text,
        body: _messageController.text,
        errorCallback: () {},
        doneCallback: () => setState(() {
          _subjectController.clear();
          _messageController.clear();
          _isButtonEnabled = false;
        }),
      );

  void _onChanged(String value) => setState(
        () => _isButtonEnabled = _subjectController.text.isNotEmpty &&
            _messageController.text.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          child: SafeArea(
            child: Row(
              children: [
                AppBackButton(),
                SizedBox(width: 9),
                Expanded(
                  child: AppBanner(label: 'Contact with support'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContactInput(
              onChanged: _onChanged,
              controller: _subjectController,
              placeholder: 'Subject',
            ),
            SizedBox(height: 19),
            _ContactInput(
              onChanged: _onChanged,
              controller: _messageController,
              placeholder: 'Message',
            ),
            SizedBox(height: 74),
            AppButton(
              label: 'Send',
              onPressed: _send,
              isActive: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInput extends StatelessWidget {
  final void Function(String) onChanged;
  final String placeholder;
  final TextEditingController controller;
  const _ContactInput({
    required this.onChanged,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: CupertinoTextField(
        padding: EdgeInsets.symmetric(horizontal: 10),
        controller: controller,
        onChanged: onChanged,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12)
        ),
        placeholder: placeholder,
        placeholderStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
