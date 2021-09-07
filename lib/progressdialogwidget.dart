import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDiaogWidget extends StatefulWidget {
  @override
  _ProgressDiaogWidgetState createState() => _ProgressDiaogWidgetState();
}

class _ProgressDiaogWidgetState extends State<ProgressDiaogWidget> {

  late Subscription subscription;
  double? progress;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((progress){
      setState(() {
        this.progress = progress;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    VideoCompress.cancelCompression();
    subscription.unsubscribe;
    VideoCompress.dispose();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    height = height / 100;
    width = width / 100;
    final value = progress == Null? progress : progress! / 100;
    return Container(
      height: height * 28,
      color: Color(0xffABF7FD),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 25,
      child: Column(
        children: [
          SizedBox(height: height * 3,),
          Container(
              height: height * 5,
              width: width * 50,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText("Compressing video...",textStyle:GoogleFonts.paytoneOne(
                      fontSize: height * 2.1,
                      color: Color(0xff04393C),
                      fontWeight: FontWeight.w800),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 4,
                pause: const Duration(milliseconds: 100),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              )
          ),
          SizedBox(height: height * 3,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 4),
            child: LinearProgressIndicator(
              color: Colors.red,
              backgroundColor: Colors.blueGrey,
              value: value,
              semanticsLabel: "Processing",
              minHeight: height * 5,),
          ),
          SizedBox(height: 5 * height,),
          InkWell(
            onTap: () => VideoCompress.cancelCompression(),
            child: Container(
              height: height * 3.5,
              width: width * 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xff04393C),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.paytoneOne(
                    fontSize: height * 2.2, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
