import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  InAppWebViewController? webViewController;
  double progress = 0.0;
  bool loaderVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      appBar: CustomAppBar(
        AppText(
          localization.privacy_policy,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(
                Uri.parse("https://bhawsarchemicals.com/privacy-policy-2/"),
              ),
            ),
            onWebViewCreated: (controller) {
              setState(() {
                loaderVisibility = true;
              });
            },
            onLoadStart: (controller, url) {
              setState(() {
                loaderVisibility = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                loaderVisibility = false;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                // You can use this to show progress in the UI
                print("Progress: $progress%");
                this.progress = progress / 100;
              });
            },
          ),
          Visibility(
            visible: loaderVisibility,
            child: Center(
                child: CircularProgressIndicator(
              value: progress,
            )),
          ),
        ],
      ),
    );
  }
}
