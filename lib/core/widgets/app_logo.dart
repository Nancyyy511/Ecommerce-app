import 'package:flutter/widgets.dart';

import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.white = false, this.width = 237});

  final bool white;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      white ? AppAssets.whiteLogo : AppAssets.blueLogo,
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'Route',
    );
  }
}
