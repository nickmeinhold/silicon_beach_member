import 'package:flutter/material.dart' hide Action;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:silicon_beach_member/models/actions.dart';
import 'package:silicon_beach_member/models/app_state.dart';
import 'package:silicon_beach_member/models/user.dart';
import 'package:silicon_beach_member/widgets/auth_page.dart';
import 'package:silicon_beach_member/widgets/main_page.dart';

class SiliconBeachApp extends StatefulWidget {
  SiliconBeachApp(this.store);
  final Store<AppState> store;
  @override
  _SiliconBeachAppState createState() => _SiliconBeachAppState();
}

class _SiliconBeachAppState extends State<SiliconBeachApp> {
  @override
  void initState() {
    super.initState();
    widget.store.dispatch(Action.ObserveAuthState());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider<AppState>(
        store: widget.store,
        child: StoreConnector<AppState, User>(
          distinct: true,
          converter: (store) => store.state.user,
          builder: (context, user) {
            return (user == null || user.uid == null) ? AuthPage() : MainPage();
          },
        ),
      ),
    );
  }
}
