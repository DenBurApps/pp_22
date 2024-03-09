import 'package:flutter/material.dart';
import 'package:pp_22/presentation/modules/agreement_view.dart';
import 'package:pp_22/presentation/modules/coin_details/view/coin_details_view.dart';
import 'package:pp_22/presentation/modules/contact_support_view.dart';
import 'package:pp_22/presentation/modules/onboarding_view.dart';
import 'package:pp_22/presentation/modules/pages/camera/view/camera_view.dart';
import 'package:pp_22/presentation/modules/pages/collections/views/collection_view.dart';
import 'package:pp_22/presentation/modules/pages/pages_view.dart';
import 'package:pp_22/presentation/modules/paywall/view/paywall_view.dart';
import 'package:pp_22/presentation/modules/privacy_view.dart';
import 'package:pp_22/presentation/modules/search/views/camera_search_view.dart';
import 'package:pp_22/presentation/modules/search/views/query_search_view.dart';
import 'package:pp_22/presentation/modules/settings_view.dart';
import 'package:pp_22/presentation/modules/splash_view.dart';
import 'package:pp_22/presentation/modules/subscription_status_view.dart';

part 'route_names.dart';

typedef AppRoute = Widget Function(BuildContext context);

class AppRoutes {
  static Map<String, AppRoute> get(BuildContext context) => {
        RouteNames.splash: (context) => const SplashView(),
        RouteNames.onboarding: (context) => const OnboardingView(),
        RouteNames.privacy: (context) => const PrivacyView(),
        RouteNames.pages: (context) => const PagesView(),
        RouteNames.camera: (context) => const CameraView(),
        RouteNames.settings: (context) => const SettingsView(),
        RouteNames.agreement: (context) => AgreementView.create(context),
        RouteNames.contactSupport: (context) => const ContactSupportView(),
        RouteNames.collection: (context) => CollectionView.create(context),
        RouteNames.search: (context) => const QuerySearchView(),
        RouteNames.cameraSearch: (context) => CameraSearchView.create(context),
        RouteNames.coinDetails: (context) => CoinDetailsView.create(context),
        RouteNames.paywall:(context) => PayWallView.create(context), 
        RouteNames.subscription:(context) => const SubscriptionStatusView(), 
      };
}
