



import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nobowa/model/models.dart';
import 'package:nobowa/view/widget/accessories.dart';
import 'package:nobowa/view/widget/dialogs.dart';


class Website extends StatefulWidget {
  const Website({Key? key}) : super(key: key);

  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {

  bool loading = false;

  final GlobalKey webViewKey = GlobalKey();

  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
  );

  late PullToRefreshController pullToRefreshController;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Utils.brownColor,
      ),
      onRefresh: () async {
        webViewController.reload();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                  URLRequest(url: Uri.parse("https://nobowa.com/")),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                    setState(() {loading = true;});
                  },
                  onLoadStart: (controller, url) {
                    setState(() {loading = true;});
                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    var url = navigationAction.request.url!.toString();
                    if (url.startsWith('https://nobowa.com/')) {
                      return NavigationActionPolicy.ALLOW;
                    }else{
                      externalLinkDialog(context, url);
                      return NavigationActionPolicy.CANCEL;
                    }

                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {loading = false;});
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    setState(() {loading = false;});
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress,color: Utils.brownColor,backgroundColor: Utils.yellowColor,)
                    : const SizedBox(),
              ],
            ),
          ),
          Container(
            height: 55,
            color: Utils.brownColor,
            child: ButtonBar(
              mainAxisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.brownColor)),
                  child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                  onPressed: () {
                    webViewController.goBack();
                  },
                ),
                floatingActionButton(context),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.brownColor)),
                  child: Icon(Icons.arrow_forward,color: Colors.white,size: 30,),
                  onPressed: () {
                    webViewController.goForward();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

}




