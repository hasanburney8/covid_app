import 'dart:async';
import 'package:covid_tracker/view/world_states.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{   //TickerProviderStateMixin is used to build animations


  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this)..repeat();
  @override

  void dispose(){                          //this disconnects the controller from screen decreasing the load on app
    super.dispose();
    _controller.dispose();                 //this disconnects the controller from screen decreasing the load on app
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 5),     //this tells when to start splash screen
            () => Navigator.push(context,MaterialPageRoute(builder: (context)=>WorldStatesScreen()))   //this tells which screen to move on to next
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            AnimatedBuilder(
                animation: _controller,
                child: Container(
                  height: 200,
                  width: 200,
                  child: const Center(
                    child: Image(image: AssetImage('images/virus.png')),
                  ),
                ),
                builder: (BuildContext context, Widget? child){
                  return Transform.rotate(
                    angle: _controller.value * 2.0 * math.pi,
                    child: child,//the second is the one at line 45
                  );
                }
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
            Align(
              alignment: Alignment.center,
              child: Text('Covid-19\ Tracker App',textAlign: TextAlign.center,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),),
            )
          ],
        ),
      ),
    );
  }
}
