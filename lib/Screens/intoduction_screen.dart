import 'package:clear_flutterapp/Screens/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:clear_flutterapp/Models/causrosel_data.dart';
import 'package:clear_flutterapp/Models/caurose_data_model.dart';



class SliderBaseClass extends StatefulWidget {
  @override
  _SliderBaseClassState createState() => _SliderBaseClassState();
}

class _SliderBaseClassState extends State<SliderBaseClass> {
  final introKey = GlobalKey<IntroductionScreenState>();
  CauroselData data = CauroselData();

  static const pageDecoration = const PageDecoration(
    bodyFlex: 1,
    imageFlex: 3,
    // imagePadding: EdgeInsets.only(bottom: 24.0),
    titleTextStyle: TextStyle(fontSize: 22.0, color: Colors.black87),
    bodyTextStyle: TextStyle(fontSize: 20.0, color: Colors.black87),
    pageColor: Colors.black12,
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  );

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => ToDoList()),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/$assetName',
      fit: BoxFit.cover,
      height: 400,
      width: width,
    );
  }

  List<PageViewModel> getPageViewModel() {
    List<PageViewModel> pageView = [];
    for (CausroselDataModel model in data.cauroselData) {
      var newItem = PageViewModel(

          title: model.headlineText,
          body: model.bodyText,
          image: _buildImage(model.imageName),
          decoration: pageDecoration
      );
      pageView.add(newItem);
    }
    return pageView;
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPageViewModel(),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      curve: Curves.fastLinearToSlowEaseIn,
      done: Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
      skip: Text('Skip', style: TextStyle(color: Colors.black87)),
      next: Icon(Icons.arrow_forward, color: Colors.black87),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      dotsDecorator: DotsDecorator (
        size: Size(10, 10),
        color: Colors.grey,
        activeColor: Colors.black,
        activeShape: RoundedRectangleBorder (
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),

    );
  }


}


