import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final smallestSize = width < height ? width : height;
    final circleRadius = smallestSize * 0.6;

    return Scaffold(
      body: SafeArea(
        child: Binding<UserModel>(
          source: BindingSource.of<UserModel>(context),
          path: UserModel.isLoadingPropertyName,
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
                      path: UserModel.isTimerRunningPropertyName,
                      builder: (_, userModel) => CircularPercentIndicator(
                        radius: circleRadius,
                        lineWidth: 30.0,
                        percent: userModel.todayPercentage,
                        animation: true,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${userModel.todayMinutesRemaining} minutes',
                              style: TextStyle(fontSize: 30),
                            ),
                            Text('Remaining'),
                          ],
                        ),
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: circleRadius,
                        child: Binding<UserModel>(
                          source: userModel,
                          path: UserModel.timerStartTimePropertyName,
                          builder: (_, userModel) =>
                              userModel.timerStartTime == null
                                  ? RaisedButton(
                                      child: Text('Start'),
                                      onPressed: userModel.startTimer,
                                      color: Colors.green,
                                    )
                                  : RaisedButton(
                                      child: Text('Stop'),
                                      onPressed: userModel.stopTimer,
                                      color: Colors.red,
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
