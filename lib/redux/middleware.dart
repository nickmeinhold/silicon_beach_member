import 'package:redux/redux.dart';
import 'package:silicon_beach_member/models/actions.dart';
import 'package:silicon_beach_member/models/app_state.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createMiddleware(
    AuthService authService, FirestoreService firestoreService) {
  return [
    TypedMiddleware<AppState, ObserveAuthState>(
      _observeAuthState(authService),
    ),
    TypedMiddleware<AppState, SigninWithGoogle>(
      _signinWithGoogle(authService),
    ),
  ];
}

void Function(
        Store<AppState> store, ObserveAuthState action, NextDispatcher next)
    _observeAuthState(AuthService authService) {
  return (Store<AppState> store, ObserveAuthState action,
      NextDispatcher next) async {
    next(action);

    // listen to the stream that emits actions on any auth change
    // and call dispatch on the action
    authService.streamOfStateChanges.listen(store.dispatch);
  };
}

void Function(
        Store<AppState> store, SigninWithGoogle action, NextDispatcher next)
    _signinWithGoogle(AuthService authService) {
  return (Store<AppState> store, SigninWithGoogle action,
      NextDispatcher next) async {
    next(action);

    // signin and listen to the stream and dispatch actions
    authService.googleSignInStream.listen(store.dispatch);
  };
}
