import 'dart:typed_data';

import 'package:pp_22/models/coin.dart';
import 'package:pp_22/models/collection.dart';
import 'package:pp_22/presentation/modules/agreement_view.dart';

class AgreementViewArguments {
  final AgreementType agreementType;
  final bool usePrivacyAgreement;
  final bool isFromOnboarding;
  const AgreementViewArguments({
    required this.agreementType,
    this.usePrivacyAgreement = false,
    this.isFromOnboarding = false, 
  });
}

class CollectionViewArguments {
  final int index;
  final Collection collection;

  const CollectionViewArguments({
    required this.index,
    required this.collection,
  });
}

class CameraSearchViewArguments {
  final Uint8List obverse;
  final Uint8List reverse;

  const CameraSearchViewArguments({
    required this.obverse,
    required this.reverse,
  });
}

class CoinDetailsViewArguments {
  final Coin coin;
  const CoinDetailsViewArguments({
    required this.coin,
  });
}

class PaywallViewArguments {
  final bool isFromOnboarding;
  final bool isFromSubscriptionStatus;
  PaywallViewArguments({
    this.isFromOnboarding = false,
    this.isFromSubscriptionStatus = false, 
  });
}
