import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_constant.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  static bool isShowingAd = false;
  // Datum adsModel = Datum();

  /// Load an AppOpenAd.
  Future<void> loadAd({required String id}) async {
    await AppOpenAd.load(
      adUnitId: "$id",
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  Future<void> loadSplashAds({required String id}) async {
    return AppOpenAd.load(
      adUnitId: "$id",
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      loadAd(id: AdConstants.appOpenAdsId);
      return;
    } else {
      _appOpenAd!.show();
    }
    if (isShowingAd) {
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd(id: AdConstants.appOpenAdsId);
      },
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }
}

// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class OpenAppAdsUtils {
//
//  static AppOpenAd? openAd;
//
//
//
//  static Future<void> loadAd() async {
//     await AppOpenAd.load(
//         adUnitId: 'ca-app-pub-3940256099942544/3419835294',
//         request: const AdRequest(),
//         adLoadCallback: AppOpenAdLoadCallback(
//             onAdLoaded: (ad){
//               print('ad is loaded');
//               openAd = ad;
//               print('ad is loaded done==>$openAd');
//               openAd!.show();
//             },
//             onAdFailedToLoad: (error) {
//               print('ad failed to load $error');
//             }), orientation: AppOpenAd.orientationPortrait
//     );
//   }
// }
