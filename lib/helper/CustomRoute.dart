import 'package:flutter/material.dart';

//single route
class CustomRoute<T> extends MaterialPageRoute<T>{
  CustomRoute({WidgetBuilder builder, RouteSettings settings}): super(builder: builder,settings :settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

    if(settings.isInitialRoute){
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  //  return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}


//General theme
class CustomPageTransitionsBuilder extends PageTransitionsBuilder{
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if(route.settings.isInitialRoute){
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }

}