import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:picco/services/log_service.dart';

class LinkService {
  static const String kUriPrefix = 'https://piccoflutter.page.link';
  static const String kProductPage = "/productPage?id=";

  // static Future<Uri> createLongLink(String partnerId) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     link: Uri.parse("https://adminPicco?partnerId=$partnerId"),
  //     uriPrefix: "https://piccoflutter.page.link",
  //     androidParameters:
  //     const AndroidParameters(packageName: "com.example.picco"),
  //     iosParameters: const IOSParameters(
  //       bundleId: "com.example.picco",
  //       minimumVersion: "13.0",
  //       // appStoreId: "iosId",
  //     ),
  //     navigationInfoParameters:
  //     const NavigationInfoParameters(forcedRedirectEnabled: true),
  //   );
  //
  //   final Uri uri = await FirebaseDynamicLinks.instance.buildLink(parameters);
  //   return uri;
  // }

  static Future<Uri> createShortLink(String houseId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + kProductPage + houseId),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.picco',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.picco',
        minimumVersion: '13.0',
        // appStoreId: '1605546414',
      ),
      navigationInfoParameters:
          const NavigationInfoParameters(forcedRedirectEnabled: true),
    );

    var shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    var shortUrl = shortLink.shortUrl;
    return shortUrl;
  }

  static Future<Uri?> retrieveDynamicLink() async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      return deepLink;
    } catch (e) {
      Log.e(e.toString());
    }

    return null;
  }
}
