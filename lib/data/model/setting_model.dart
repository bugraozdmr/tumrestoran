import 'dart:convert';

SettingModel settingModelFromJson(String str) =>
    SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  final Data? data;

  SettingModel({this.data});

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final String? companyName;
  final String? companyEmail;
  final String? companyPhone;
  final String? companyAddress;
  final String? companyCountryCode;
  final int? siteDefaultLanguage;
  final String? siteCopyright;
  final int? siteCurrencyPosition;
  final int? siteDigitAfterDecimalPoint;
  final String? siteDefaultCurrencySymbol;
  final int? sitePhoneVerification;
  final int? siteLanguageSwitch;
  final int? siteCashOnDelivery;
  final int? siteOnlinePaymentGateway;
  final int? siteDefaultCurrency;
  final int? siteRestaurantSearchRadius;
  final int? siteDeliveryBoyOrderRadius;
  final int? siteEmailVerification;
  final int? siteServiceFee;
  final String? themeLogo;
  final String? themeFooterLogo;
  final String? themeFaviconLogo;
  final String? otpType;
  final String? otpDigitLimit;
  final String? otpExpireTime;
  final String? socialMediaFacebook;
  final String? socialMediaInstagram;
  final String? socialMediaTwitter;
  final String? socialMediaYoutube;
  final dynamic deliverySetupFreeDeliveryKilometer;
  final dynamic deliverySetupBasicDeliveryFee;
  final dynamic deliverySetupChargePerKilo;
  final int? cookiesDetailsPageId;
  final String? cookiesSummary;
  final String? notificationFcmApiKey;
  final String? notificationFcmAuthDomain;
  final String? notificationFcmProjectId;
  final String? notificationFcmStorageBucket;
  final String? notificationFcmMessagingSenderId;
  final String? notificationFcmAppId;
  final String? notificationFcmMeasurementId;
  final String? notificationFcmPublicVapidKey;
  final String? notificationAudio;
  final String? frontendHeroSectionTitle;
  final String? frontendHeroSectionSubTitle;
  final String? frontendAppSectionTitle;
  final String? frontendAppSectionAndroidAppLink;
  final String? frontendAppSectionIsoAppLink;
  final String? frontendAboutTitle;
  final String? frontendRestaurantSectionTitle;
  final String? frontendRestaurantSectionSubTitle;
  final String? frontendDeliverySectionTitle;
  final String? frontendDeliverySectionSubTitle;
  final String? frontendHeroSectionImage;
  final String? frontendAppSectionImage;
  final String? frontendRestaurantSectionImage;
  final String? frontendDeliverySectionImage;
  final String? imageAppStore;
  final String? imagePlayStore;
  final String? imageVag;
  final String? imageNonVag;
  final String? imageConfirm;
  final String? imageOrderTrack;
  final String? imageOrderPlaced;
  final String? imageOrderComplete;
  final String? imageOrderDelivered;
  final String? imageOrderPreparing;
  final String? imageOrderOutForDelivery;
  final String? imageOrderRejected;
  final String? imageOrderCanceled;
  final String? imageOrderReturned;
  final int? siteRidertip;
  final int? siteCutlery;
  final int? termsAndConditionCustomerId;
  final String? themePrimaryColor;

  Data({
    this.companyName,
    this.companyEmail,
    this.companyPhone,
    this.companyAddress,
    this.companyCountryCode,
    this.siteServiceFee,
    this.siteDefaultLanguage,
    this.siteCopyright,
    this.siteCurrencyPosition,
    this.siteDigitAfterDecimalPoint,
    this.siteDefaultCurrencySymbol,
    this.sitePhoneVerification,
    this.siteLanguageSwitch,
    this.siteCashOnDelivery,
    this.siteOnlinePaymentGateway,
    this.siteDefaultCurrency,
    this.siteRestaurantSearchRadius,
    this.siteDeliveryBoyOrderRadius,
    this.themeLogo,
    this.themeFooterLogo,
    this.themeFaviconLogo,
    this.otpType,
    this.otpDigitLimit,
    this.otpExpireTime,
    this.socialMediaFacebook,
    this.socialMediaInstagram,
    this.socialMediaTwitter,
    this.socialMediaYoutube,
    this.deliverySetupFreeDeliveryKilometer,
    this.deliverySetupBasicDeliveryFee,
    this.deliverySetupChargePerKilo,
    this.cookiesDetailsPageId,
    this.cookiesSummary,
    this.notificationFcmApiKey,
    this.notificationFcmAuthDomain,
    this.notificationFcmProjectId,
    this.notificationFcmStorageBucket,
    this.notificationFcmMessagingSenderId,
    this.notificationFcmAppId,
    this.notificationFcmMeasurementId,
    this.notificationFcmPublicVapidKey,
    this.notificationAudio,
    this.frontendHeroSectionTitle,
    this.frontendHeroSectionSubTitle,
    this.frontendAppSectionTitle,
    this.frontendAppSectionAndroidAppLink,
    this.frontendAppSectionIsoAppLink,
    this.frontendAboutTitle,
    this.frontendRestaurantSectionTitle,
    this.frontendRestaurantSectionSubTitle,
    this.frontendDeliverySectionTitle,
    this.frontendDeliverySectionSubTitle,
    this.frontendHeroSectionImage,
    this.frontendAppSectionImage,
    this.frontendRestaurantSectionImage,
    this.frontendDeliverySectionImage,
    this.imageAppStore,
    this.imagePlayStore,
    this.imageVag,
    this.imageNonVag,
    this.imageConfirm,
    this.imageOrderTrack,
    this.imageOrderPlaced,
    this.imageOrderComplete,
    this.imageOrderDelivered,
    this.imageOrderPreparing,
    this.imageOrderOutForDelivery,
    this.imageOrderRejected,
    this.imageOrderCanceled,
    this.imageOrderReturned,
    this.siteRidertip,
    this.siteCutlery,
    this.siteEmailVerification,
    this.termsAndConditionCustomerId,
    this.themePrimaryColor,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    companyName: json["company_name"],
    companyEmail: json["company_email"],
    companyPhone: json["company_phone"],
    companyAddress: json["company_address"],
    siteServiceFee: json["site_service_fee"],
    companyCountryCode: json["company_country_code"],
    siteDefaultLanguage: json["site_default_language"],
    siteCopyright: json["site_copyright"],
    siteCurrencyPosition: json["site_currency_position"],
    siteDigitAfterDecimalPoint: json["site_digit_after_decimal_point"],
    siteDefaultCurrencySymbol: json["site_default_currency_symbol"],
    sitePhoneVerification: json["site_phone_verification"],
    siteLanguageSwitch: json["site_language_switch"],
    siteCashOnDelivery: json["site_cash_on_delivery"],
    siteOnlinePaymentGateway: json["site_online_payment_gateway"],
    siteDefaultCurrency: json["site_default_currency"],
    siteRestaurantSearchRadius: json["site_restaurant_search_radius"],
    siteDeliveryBoyOrderRadius: json["site_delivery_boy_order_radius"],
    themeLogo: json["theme_logo"],
    themeFooterLogo: json["theme_footer_logo"],
    themeFaviconLogo: json["theme_favicon_logo"],
    otpType: json["otp_type"],
    otpDigitLimit: json["otp_digit_limit"],
    otpExpireTime: json["otp_expire_time"],
    socialMediaFacebook: json["social_media_facebook"],
    socialMediaInstagram: json["social_media_instagram"],
    socialMediaTwitter: json["social_media_twitter"],
    socialMediaYoutube: json["social_media_youtube"],
    deliverySetupFreeDeliveryKilometer:
        json["delivery_setup_free_delivery_kilometer"],
    deliverySetupBasicDeliveryFee: json["delivery_setup_basic_delivery_fee"],
    deliverySetupChargePerKilo: json["delivery_setup_charge_per_kilo"],
    cookiesDetailsPageId: json["cookies_details_page_id"],
    cookiesSummary: json["cookies_summary"],
    notificationFcmApiKey: json["notification_fcm_api_key"],
    notificationFcmAuthDomain: json["notification_fcm_auth_domain"],
    notificationFcmProjectId: json["notification_fcm_project_id"],
    notificationFcmStorageBucket: json["notification_fcm_storage_bucket"],
    notificationFcmMessagingSenderId:
        json["notification_fcm_messaging_sender_id"],
    notificationFcmAppId: json["notification_fcm_app_id"],
    notificationFcmMeasurementId: json["notification_fcm_measurement_id"],
    notificationFcmPublicVapidKey: json["notification_fcm_public_vapid_key"],
    notificationAudio: json["notification_audio"],
    frontendHeroSectionTitle: json["frontend_hero_section_title"],
    frontendHeroSectionSubTitle: json["frontend_hero_section_sub_title"],
    frontendAppSectionTitle: json["frontend_app_section_title"],
    frontendAppSectionAndroidAppLink:
        json["frontend_app_section_android_app_link"],
    frontendAppSectionIsoAppLink: json["frontend_app_section_iso_app_link"],
    frontendAboutTitle: json["frontend_about_title"],
    frontendRestaurantSectionTitle: json["frontend_restaurant_section_title"],
    frontendRestaurantSectionSubTitle:
        json["frontend_restaurant_section_sub_title"],
    frontendDeliverySectionTitle: json["frontend_delivery_section_title"],
    frontendDeliverySectionSubTitle:
        json["frontend_delivery_section_sub_title"],
    frontendHeroSectionImage: json["frontend_hero_section_image"],
    frontendAppSectionImage: json["frontend_app_section_image"],
    frontendRestaurantSectionImage: json["frontend_restaurant_section_image"],
    frontendDeliverySectionImage: json["frontend_delivery_section_image"],
    imageAppStore: json["image_app_store"],
    imagePlayStore: json["image_play_store"],
    imageVag: json["image_vag"],
    imageNonVag: json["image_non_vag"],
    imageConfirm: json["image_confirm"],
    imageOrderTrack: json["image_order_track"],
    imageOrderPlaced: json["image_order_placed"],
    imageOrderComplete: json["image_order_complete"],
    imageOrderDelivered: json["image_order_delivered"],
    imageOrderPreparing: json["image_order_preparing"],
    imageOrderOutForDelivery: json["image_order_out_for_delivery"],
    imageOrderRejected: json["image_order_rejected"],
    imageOrderCanceled: json["image_order_canceled"],
    imageOrderReturned: json["image_order_returned"],
    siteRidertip: json['site_rider_tip'],
    siteCutlery: json['site_cutlery'],
    siteEmailVerification: json['site_email_verification'],
    termsAndConditionCustomerId:
        json['terms_and_conditions_customer_page_id'] ?? 0,
    themePrimaryColor: json['theme_primary_color'] ?? '#FF6B00',
  );

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "company_email": companyEmail,
    "company_phone": companyPhone,
    "company_address": companyAddress,
    "company_country_code": companyCountryCode,
    "site_default_language": siteDefaultLanguage,
    "site_copyright": siteCopyright,
    "site_currency_position": siteCurrencyPosition,
    "site_digit_after_decimal_point": siteDigitAfterDecimalPoint,
    "site_default_currency_symbol": siteDefaultCurrencySymbol,
    "site_phone_verification": sitePhoneVerification,
    "site_language_switch": siteLanguageSwitch,
    "site_cash_on_delivery": siteCashOnDelivery,
    "site_online_payment_gateway": siteOnlinePaymentGateway,
    "site_default_currency": siteDefaultCurrency,
    "site_restaurant_search_radius": siteRestaurantSearchRadius,
    "site_delivery_boy_order_radius": siteDeliveryBoyOrderRadius,
    "theme_logo": themeLogo,
    "theme_footer_logo": themeFooterLogo,
    "theme_favicon_logo": themeFaviconLogo,
    "otp_type": otpType,
    "otp_digit_limit": otpDigitLimit,
    "otp_expire_time": otpExpireTime,
    "social_media_facebook": socialMediaFacebook,
    "social_media_instagram": socialMediaInstagram,
    "social_media_twitter": socialMediaTwitter,
    "social_media_youtube": socialMediaYoutube,
    "delivery_setup_free_delivery_kilometer":
        deliverySetupFreeDeliveryKilometer,
    "delivery_setup_basic_delivery_charge": deliverySetupBasicDeliveryFee,
    "delivery_setup_charge_per_kilo": deliverySetupChargePerKilo,
    "cookies_details_page_id": cookiesDetailsPageId,
    "cookies_summary": cookiesSummary,
    "notification_fcm_api_key": notificationFcmApiKey,
    "notification_fcm_auth_domain": notificationFcmAuthDomain,
    "notification_fcm_project_id": notificationFcmProjectId,
    "notification_fcm_storage_bucket": notificationFcmStorageBucket,
    "notification_fcm_messaging_sender_id": notificationFcmMessagingSenderId,
    "notification_fcm_app_id": notificationFcmAppId,
    "notification_fcm_measurement_id": notificationFcmMeasurementId,
    "notification_fcm_public_vapid_key": notificationFcmPublicVapidKey,
    "notification_audio": notificationAudio,
    "frontend_hero_section_title": frontendHeroSectionTitle,
    "frontend_hero_section_sub_title": frontendHeroSectionSubTitle,
    "frontend_app_section_title": frontendAppSectionTitle,
    "frontend_app_section_android_app_link": frontendAppSectionAndroidAppLink,
    "frontend_app_section_iso_app_link": frontendAppSectionIsoAppLink,
    "frontend_about_title": frontendAboutTitle,
    "frontend_restaurant_section_title": frontendRestaurantSectionTitle,
    "frontend_restaurant_section_sub_title": frontendRestaurantSectionSubTitle,
    "frontend_delivery_section_title": frontendDeliverySectionTitle,
    "frontend_delivery_section_sub_title": frontendDeliverySectionSubTitle,
    "frontend_hero_section_image": frontendHeroSectionImage,
    "frontend_app_section_image": frontendAppSectionImage,
    "frontend_restaurant_section_image": frontendRestaurantSectionImage,
    "frontend_delivery_section_image": frontendDeliverySectionImage,
    "image_app_store": imageAppStore,
    "image_play_store": imagePlayStore,
    "image_vag": imageVag,
    "image_non_vag": imageNonVag,
    "image_confirm": imageConfirm,
    "image_order_track": imageOrderTrack,
    "image_order_placed": imageOrderPlaced,
    "image_order_complete": imageOrderComplete,
    "image_order_delivered": imageOrderDelivered,
    "image_order_preparing": imageOrderPreparing,
    "image_order_out_for_delivery": imageOrderOutForDelivery,
    "image_order_rejected": imageOrderRejected,
    "image_order_canceled": imageOrderCanceled,
    "image_order_returned": imageOrderReturned,
    "site_rider_tip": siteRidertip,
    "site_cutlery": siteCutlery,
    "site_email_verification": siteEmailVerification,
    "terms_and_conditions_customer_page_id": termsAndConditionCustomerId,
    "theme_primary_color": themePrimaryColor,
  };
}
