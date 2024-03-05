import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:pp_22/helpers/email_helper.dart';

import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';

class ContactSupportView extends StatefulWidget {
  const ContactSupportView({super.key});

  @override
  State<ContactSupportView> createState() => _ContactSupportViewState();
}

class _ContactSupportViewState extends State<ContactSupportView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
      toEmail: 'ksuvei@finconte.site',
      subject: _subjectController.text,
      body: _messageController.text,
      errorCallback: () {},
      doneCallback: () {
        _subjectController.clear();
        _messageController.clear();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30),
                  Text(
                    'Contact developer',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  AppCloseButton()
                ],
              ),
              SizedBox(height: 40),
              _ContactInput(
                controller: _subjectController,
                placeholder: 'Subject',
              ),
              SizedBox(height: 19),
              _ContactInput(
                controller: _messageController,
                placeholder: 'Message',
              ),
              SizedBox(height: 60),
              MultiValueListenableBuilder(
                valueListenables: [
                  _messageController,
                  _subjectController,
                ],
                builder: (context, values, child) => AppButton(
                  label: 'Send',
                  onPressed: _send,
                  isActive: (values.elementAt(0) as TextEditingValue)
                          .text
                          .isNotEmpty &&
                      (values.elementAt(1) as TextEditingValue).text.isNotEmpty,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInput extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  const _ContactInput({
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CupertinoTextField(
        padding: EdgeInsets.symmetric(horizontal: 10),
        controller: controller,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.circular(30),
        ),
        placeholder: placeholder,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
        ),
        placeholderStyle: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
      ),
    );
  }
}
