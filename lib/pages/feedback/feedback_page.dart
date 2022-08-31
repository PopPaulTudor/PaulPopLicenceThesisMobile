import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licenta/theme/app_colors.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 250,
                child: SvgPicture.asset("assets/opinion.svg",
                    semanticsLabel: "opinion"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: DefaultTextStyle(style: TextStyle(color: Colors.black, fontSize: 25), child: Text("What do you think about the project?", )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RatingBar.builder(
                  initialRating: 4,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppColors.primaryColor,
                  ),
                  onRatingUpdate: (double value) {},
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: DefaultTextStyle(style: TextStyle(color: Colors.black, fontSize: 20), child: Text("Leave me feedback")),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: AppColors.powderBlue)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Thank you for the feedback"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Submit"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 100)),
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
