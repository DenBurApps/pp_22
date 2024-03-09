import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_22/models/arguments.dart';
import 'package:pp_22/presentation/components/app_button.dart';
import 'package:pp_22/presentation/components/app_close_button.dart';
import 'package:pp_22/routes/routes.dart';
import 'package:pp_22/services/repositories/subscription_repository.dart';

class SubscriptionStatusView extends StatefulWidget {
  const SubscriptionStatusView({super.key});

  @override
  State<SubscriptionStatusView> createState() => _SubscriptionStatusViewState();
}

class _SubscriptionStatusViewState extends State<SubscriptionStatusView> {
  final _subscriptionRepository = GetIt.instance<SubscriptionRepositoy>();

  DateTime? get _expirationDate => DateTime.tryParse(
      _subscriptionRepository.value.customerInfo!.latestExpirationDate!);

  String _getDateStringFormatted() {
    if (_expirationDate != null) {
      final month = _expirationDate!.month < 10
          ? '0${_expirationDate!.month}'
          : '${_expirationDate!.month}';
      final day = _expirationDate!.day < 10
          ? '0${_expirationDate!.day}'
          : '${_expirationDate!.day}';
      final year = _expirationDate!.year;
      return '$month/$day/$year';
    } else {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 30),
                  Text(
                    'Subscription status',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  AppCloseButton()
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _subscriptionRepository,
                  builder: (context, value, child) {
                    if (!value.userHasPremium) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You don't have active\nsubscription",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppButton(
                              label: "Let's make purchase",
                              onPressed: () => Navigator.of(context).pushNamed(
                                RouteNames.paywall,
                                arguments: PaywallViewArguments(),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status:'),
                              Text('Active'),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Expiration date: '),
                              Text(
                                _getDateStringFormatted(),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
