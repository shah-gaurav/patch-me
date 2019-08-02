import 'package:binding/binding.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'timer_widget.dart';
import 'settings_widget.dart';

class UserPage extends StatefulWidget {
  static const routeName = 'user';

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  UserModel _passedInModel;
  bool _initialized = false;

  @override
  void dispose() {
    super.dispose();
    _passedInModel.cancelSubscription();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _passedInModel = ModalRoute.of(context).settings.arguments;
      _passedInModel.loadUser();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BindingSource<UserModel>(
      instance: _passedInModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _passedInModel.name,
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        body: SafeArea(
          child: Binding<UserModel>(
            source: _passedInModel,
            path: UserModel.timerStartTimePropertyName,
            builder: (_, userModel) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _widgetFromIndex(userModel),
              );
            },
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: Colors.white,
          color: Colors.blue,
          items: <Widget>[
            Icon(
              Icons.timer,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              size: 30,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
      ),
    );
  }

  Widget _widgetFromIndex(UserModel userModel) {
    if (userModel.isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );

    switch (_page) {
      case 0:
        return TimerWidget();
      case 1:
        return SettingsWidget();
      default:
        return TimerWidget();
    }
  }
}
