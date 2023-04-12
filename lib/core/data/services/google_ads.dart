import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meal_app/core/shared/utils/ad_strings.dart';

class GoogleAds {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;

  final adInterstitialUnitId = Platform.isAndroid
      ? AdStrings.interstitialAdAndroid1
      : AdStrings.interstitialAdIos1;
  final adBannerUnitId =
      Platform.isAndroid ? AdStrings.bannerAdAndroid1 : AdStrings.bannerAdIos1;
  void loadInterstitialAd(
      {bool showAfterLoad = false, bool isDebugMode = false}) {
    if (!isDebugMode) {
      InterstitialAd.load(
          adUnitId: adInterstitialUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              // Keep a reference to the ad so you can show it later.
              interstitialAd = ad;
              if (showAfterLoad) {
                showInterstitialAd();
              }
            },
            // Called when an ad request failed.
            onAdFailedToLoad: (LoadAdError error) {},
          ));
    }
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: adBannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void disposeBannerAd() {
    bannerAd?.dispose();
  }
}
