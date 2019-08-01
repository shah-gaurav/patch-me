import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../models/user_model.dart';

class UserPage extends StatelessWidget {
  static const routeName = 'user';

  @override
  Widget build(BuildContext context) {
    final UserModel passedInModel = ModalRoute.of(context).settings.arguments;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final smallestSize = width < height ? width : height;
    final circleRadius = smallestSize * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          passedInModel.name,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: SafeArea(
        child: Binding<UserModel>(
          source: passedInModel,
          path: UserModel.timerStartTimePropertyName,
          builder: (_, userModel) => userModel.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Binding<UserModel>(
                      source: userModel,
                      path: UserModel.todayTotalTimePropertyName,
                      builder: (_, userModel) => CircularPercentIndicator(
                        progressColor: Colors.green[400],
                        radius: circleRadius,
                        lineWidth: 30.0,
                        percent: userModel.todayPercentage,
                        animation: true,
                        animateFromLastPercent: true,
                        center: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            child: child,
                            scale: animation,
                          ),
                          child: (userModel.todayMinutesRemaining >= 0)
                              ? Column(
                                  key: ValueKey('underText'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      Text(
                                        '${userModel.todayMinutesRemaining} minutes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline,
                                      ),
                                      Text(
                                        'Remaining',
                                        style:
                                            Theme.of(context).textTheme.subhead,
                                      ),
                                    ])
                              : Column(
                                  key: ValueKey('overText'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Over by',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                    Text(
                                      '${userModel.todayMinutesRemaining.abs()} minutes',
                                      style:
                                          Theme.of(context).textTheme.headline,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: circleRadius,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            child: child,
                            scale: animation,
                          ),
                          child: userModel.timerStartTime == null
                              ? RaisedButton(
                                  key: ValueKey('startButton'),
                                  textColor: Colors.white,
                                  onPressed: userModel.startTimer,
                                  color: Colors.green[600],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.timer),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('START'),
                                    ],
                                  ),
                                )
                              : RaisedButton(
                                  key: ValueKey('stopButton'),
                                  textColor: Colors.white,
                                  onPressed: userModel.stopTimer,
                                  color: Colors.red[600],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GlowingProgressIndicator(
                                        child: Icon(Icons.timer),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('STOP'),
                                    ],
                                  ),
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
