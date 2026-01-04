import 'dart:async';

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({super.key, required this.paymentUrl});

  final String paymentUrl;

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  Timer? _timer;
  int _secondsLeft = 6;
  bool _showProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            if (_isSuccessUrl(url)) {
              _startProcessing();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isSuccessUrl(String url) {
    return url.contains('/payment/success/') &&
        url.contains('status=succeeded');
  }

  void _startProcessing() {
    if (_showProcessing) return;
    setState(() => _showProcessing = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_showProcessing)
              PaymentProcessingOverlay(secondsLeft: _secondsLeft),
          ],
        ),
      ),
    );
  }
}
