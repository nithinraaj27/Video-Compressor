import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:animate_icons/animate_icons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:share_extend/share_extend.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_compressor/progressdialogwidget.dart';
import 'package:video_compressor/videocompressApi.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    height = height / 100;
    width = width / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: new DecorationImage(
                          image: AssetImage("assets/splash.gif"),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(height: height * 5,),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                        "Video Compressor",textStyle: GoogleFonts.paytoneOne(color: Color(0xff0C7277),fontSize: height * 4,fontWeight: FontWeight.w200)
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ],
            )
        ),
      ),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late AnimateIconController c1;
  File? filevideo;
  Uint8List? thumbnail;
  int? videosize;
  bool? ans = false;
  bool? cmpinfo = false;
  MediaInfo? compressvideoInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c1 = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    height = height / 100;
    width = width / 100;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xff086267),
          body: Column(
            children: [
              SizedBox(
                height: height * 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 4),
                child: Container(
                  height: height * 10,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: AnimateIcons(
                              startIcon: Icons.video_call_outlined,
                              endIcon: Icons.video_call,
                              size: height * 7,
                              controller: c1,

                              onStartIconPress: () {
                                setState(() {
                                  ans = false;
                                });
                                clearselection();
                                return true;
                              },
                              onEndIconPress: () {
                                setState(() {
                                  ans = false;
                                });
                                clearselection();
                                return true;
                              },
                              duration: Duration(milliseconds: 500),
                              startIconColor: Colors.white,
                              endIconColor: Colors.tealAccent,
                              clockwise: false,
                            ),
                          )),
                      Expanded(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Video Compressor",
                              style: GoogleFonts.paytoneOne(
                                  fontSize: height * 3,
                                  color: Color(0xff04393C),
                                  fontWeight: FontWeight.w800),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 6,
              ),
              Container(
                  height: height * 65,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: ans! ? 6 : 4,
                        child: (ans!)
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: height * 30,
                              width: width * 70,
                              child: thumbnail == null ? CircularProgressIndicator() : builThumbnail(height,width),
                            ),
                            SizedBox(height: height * 2,),
                            buildvideoInfo(height),
                            Visibility(
                                visible: cmpinfo! ? true : false,
                                child: buildvidoecompressInfo(height)),
                          ],
                        )
                            : Container(
                          decoration: BoxDecoration(
                              color: Color(0xff04393C),
                              borderRadius: BorderRadius.circular(25),
                              image: new DecorationImage(
                                  scale: 0.2 * height,
                                  image: AssetImage("assets/download.gif"))),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: ans! ? Alignment.topCenter : Alignment.center,
                          child: InkWell(
                            onTap: () => ans! ? compressvideo() :pickvideo(),
                            onDoubleTap: () => ans! ? clearselection() : null,
                            child: Container(
                              height: height * 6.5,
                              width: width * 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff04393C),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                ans! ? "Compress Video": "Pick Video",
                                style: GoogleFonts.paytoneOne(
                                    fontSize: height * 2.2, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  Future pickvideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile == null) {
      MotionToast(
        icon: Icons.warning,
        color: Colors.tealAccent,
        description: "Please select the video",
      ).show(context);
    }
    final file = File(pickedFile!.path);
    setState(() {
      filevideo = file;
      ans = true;
    });

    generatethumbnail(filevideo!);
    getvideosize(filevideo!);
  }

  Future generatethumbnail(File file) async {
    final thumbnailbytes = await VideoCompress.getByteThumbnail(file.path);

    setState(() {
      thumbnail = thumbnailbytes;
    });
  }

  Future getvideosize(File file) async {
    final size = await file.length();

    setState(() {
      videosize = size;
    });
  }

  Widget builThumbnail(double height,double width)
  {
    return Container(
        height: height * 30,
        width: width * 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            image: new DecorationImage(
              image: MemoryImage(thumbnail!,),fit: BoxFit.fill,)
        )
    );
  }
  Widget buildvideoInfo(double height) {
    if(videosize == null) return Container();
    final size = videosize! / 1000;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Text("Orginal Video Info",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 2,fontWeight: FontWeight.w200)),
          SizedBox(height: height * 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              Text("Size",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
              Text("  $size  ",style: GoogleFonts.paytoneOne(color: Color(0xffF7E7DC),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
              Text("KB",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
            ],
          ),
        ],
      ),
    );
  }

  Future compressvideo() async{
    setState(() {
      cmpinfo = true;
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (contetx) => Dialog(child: ProgressDiaogWidget(),)
    );
    final info  = await VideoCompressApi.compressvideo(filevideo!);
    setState(() {
      compressvideoInfo = info;
    });
    Navigator.of(context).pop();
  }

  Widget buildvidoecompressInfo(double height)
  {
    if(compressvideoInfo == null) return Container();
    GallerySaver.saveVideo(compressvideoInfo!.path.toString());
    final size = compressvideoInfo!.filesize! / 1000;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 1),
          Text("Compressed Video Info",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 2,fontWeight: FontWeight.w200)),
          SizedBox(height: height * 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              Text("Size",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
              Text("  $size  ",style: GoogleFonts.paytoneOne(color: Color(0xffF7E7DC),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
              Text("KB",style: GoogleFonts.paytoneOne(color: Color(0xffDDF5F7),fontSize: height * 1.6,fontWeight: FontWeight.w200)),
            ],
          ),
          SizedBox(height: height * 1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () async {
                    String path = compressvideoInfo!.path.toString();
                    File f  =   new File(path);
                    ShareExtend.share(f.path,"Your Compressed Video,App made by Nithinraaj");
                  },
                  child: Text("SHARE",style: GoogleFonts.paytoneOne(color: Color(0xff3BE8F8),fontSize: height * 1.7,fontWeight: FontWeight.w200,letterSpacing: 1,decoration: TextDecoration.underline,))),
              SizedBox(width: height * 0.3,),
              InkWell(
                  onTap: () async {
                    String path = compressvideoInfo!.path.toString();
                    File f  =   new File(path);
                    ShareExtend.share(f.path,"Your Compressed Video,App made by Nithinraaj");
                  },
                  child: Icon(Icons.share,size:  1.7 * height,color: Color(0xff3BE8F8),)),
            ],
          )
        ],
      ),
    );
  }

  void clearselection()
  {
    setState(() {
      compressvideoInfo = null;
      filevideo = null;
    });
  }
}
