import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sel_it/constaints/intro_item)list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).canvasColor,
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: _introList,
    );
  }

  Widget get _introList => ListView.builder(
        itemCount: IntroList.introList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: index == IntroList.introList.length -1? BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)) : null,
              color: Color(0x66ffffff),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        IntroList.introList[index].step,
                        style: TextStyle(
                            color: Color(0x33FFFFFF),
                            fontSize: 56,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        IntroList.introList[index].step,
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                 Container(
                   margin: EdgeInsets.only(left: 15, right: 15),
                   child: SizedBox(
                     height: IntroList.introList[index].imageHeight,
                     child: Image.asset(IntroList.introList[index].image),
                   ),
                 ),
                  Expanded(child: Text( IntroList.introList[index].caption))
                ],
              ),
            ),
          );
        },
      );
}
