import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licenta/theme/app_colors.dart';

class SeeMoreElement extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final String photoName;

  const SeeMoreElement({
    Key? key,
    required this.function,
    required this.text,
    required this.photoName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: function,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.powderBlue,
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),

            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.black,fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Show more →",
                          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 10),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: SvgPicture.asset("assets/$photoName.svg",
                      semanticsLabel: photoName),
                ),
              ],
            ),

          ),
        ),
      );
  }
}
