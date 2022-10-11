import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'ad_constant.dart';
import 'ads_model.dart';
import 'ads_utils.dart';
import 'firebase_route.dart';
import 'open_app_ads.dart';

class AdvertisementController extends GetxController {
  RxList<Adsmodel> docsOfModel = <Adsmodel>[].obs;
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  late StreamSubscription<FGBGType> subscription;

  Stream<List<Adsmodel>> advertisementData() {
    return forAdvertisementData.snapshots().map((QuerySnapshot snapshot) {
      List<Adsmodel> docsOfModel = [];
      snapshot.docs.forEach((element1) {
        docsOfModel.add(Adsmodel.fromDocumentSnapshot(element1));
      });
      try {
        // AdConstants.isShowAdsOrNot = docsOfModel.first.adsShowOrNot ?? true;
        // AdConstants.interstitialId = docsOfModel.first.interstitialId ?? '';
        // AdConstants.bannerAdsId = docsOfModel.first.bannerId ?? '';
        // AdConstants.facebookInterstitialAdUnitId = docsOfModel.first.faceBookInterstitialId ?? '';
        // AdConstants.facebookBannerAdUnitId = docsOfModel.first.faceBookBannerId ?? '';
        AdConstants.isShowAdsOrNot = true;
        AdConstants.interstitialId = 'ca-app-pub-3940256099942544/1033173712';
        AdConstants.bannerAdsId = 'ca-app-pub-3940256099942544/6300978111';
        AdConstants.facebookInterstitialAdUnitId = 'IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617';
        AdConstants.facebookBannerAdUnitId = 'IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047';
        AdConstants.firstCoolDown = 5;
        AdConstants.secondCoolDown = 10;
        bool advertisementType = getInterstitialType('facebook');
        AdConstants.firstCoolDown = int.parse(docsOfModel.first.firstCountDown ?? '180');
        AdConstants.secondCoolDown = int.parse(docsOfModel.first.secondCountDown ?? '240');
        // bool advertisementType = getInterstitialType(docsOfModel.first.adMobOrFaceBook);
        AdConstants.isShowFacebookInterstitialAds = advertisementType;
        AdConstants.isShowFacebookBannerAds = advertisementType;
        AdConstants.appOpenAdsId = docsOfModel.first.appOpenAdsId ?? '';
        // print('app open id is come ----->>>>${AdConstants.appOpenAdsId}');
        appInForGroundOrBackGround();
        AdsUtils.loadInterstitialAds();
        return docsOfModel;
      } catch (e, st) {
        List<Adsmodel> docsOfModel = [];
        print("Error Message: $e : $st");
        return docsOfModel;
      }
    });
  }

  static bool getInterstitialType(String? interstitialTypeName) {
    bool isFacebookAds = false;
    if (interstitialTypeName != null) {
      isFacebookAds = interstitialTypeName == 'facebook' ? true : false;
    }
    return isFacebookAds;
  }

  void appInForGroundOrBackGround() {
    // print('app open id is come 111----->>>>${AdConstants.appOpenAdsId}');
    if (AdConstants.isShowAdsOrNot == true) {
      // print('app open id is come 222----->>>>${AdConstants.appOpenAdsId}');
      subscription = FGBGEvents.stream.listen((event) async {
        appOpenAdManager.loadAd(id: AdConstants.appOpenAdsId);
        if (event == FGBGType.foreground) {
          if (!AppOpenAdManager.isShowingAd) {
            appOpenAdManager.showAdIfAvailable();
          }
        }
        if (event == FGBGType.background) {
          appOpenAdManager.loadAd(id: AdConstants.appOpenAdsId);
        }
      });
    }
  }
}
