

import 'package:flutter/widgets.dart';
import 'package:licenta/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Container(
              color: AppColors.white,
            ),
          ),
          Center(
            child: Image(image: AssetImage("assets/loading.gif"),height: 100,)
          ),
        ],
      ),
    );
  }
}
