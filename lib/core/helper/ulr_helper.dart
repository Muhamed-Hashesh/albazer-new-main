import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  const UrlHelper._();

  static Future<void> openUrl({required String url}) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> openWhatsapp({required String number}) async {
    final url = Platform.isIOS
        ? "https://api.whatsapp.com/send?phone=$number"
        : "https://wa.me/$number";
    await openUrl(url: url);
  }

  static Future<void> openPhone({required String number}) async =>
      await openUrl(url: "tel:$number");
  static Future<void> openMap(double lat, double lng) async {
    final Uri url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Maps at $lat, $lng';
    }
  }
}
