import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:food_picker/common/utils/common_app_bar.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  static const String routeName = '/webview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: '주소 검색',
        isLeading: true,
      ),
      body: SafeArea(
        child: DaumPostcodeSearch(
          webPageTitle: '주소 검색',
          initialOption: InAppWebViewGroupOptions(),
          onConsoleMessage: (controller, message) {},
          onLoadError: (controller, url, code, message) {},
          onLoadHttpError: (controller, url, code, message) {},
          onProgressChanged: (controller, progress) {
            const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT,
            );
          },
        ),
      ),
    );
  }
}
