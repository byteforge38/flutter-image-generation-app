import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/mirror_animation_builder.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF010101),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        colors: [Color(0xFF7352FF), Color(0xFF4EB3FF)]),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Text(
                    "Your AI Buddy",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              MirrorAnimationBuilder(
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Image(
                    image: AssetImage("assets/splash.png"),
                  ),
                ),
                tween: Tween(begin: 0.98, end: 1.02),
                duration: Duration(seconds: 1),
                curve: Curves.ease,
              ),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/main'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF560FAB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
