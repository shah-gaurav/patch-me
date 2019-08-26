import 'package:binding/binding.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:patch_me/models/app_model.dart';
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
          title: Binding(
            source: _passedInModel,
            path: UserModel.namePropertyName,
            builder: (_, user) => Text(
              user.name,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                if (await _asyncConfirmDialog(context) == ConfirmAction.YES) {
                  BindingSource.of<AppModel>(context)
                      .removeUser(id: _passedInModel.userId);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
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
          backgroundColor: Theme.of(context).canvasColor,
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

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    final userModel = _passedInModel;

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Confirmation',
            style: Theme.of(context).textTheme.headline,
          ),
          content: Text(
              'Are you sure you want to delete ${userModel.name}\'s record?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.YES);
              },
            )
          ],
        );
      },
    );
  }
}
