import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LoginBloc {
  final localAuth = LocalAuthentication();
  final _availableBiometricsFetcher = PublishSubject<List<BiometricType>>();
  bool _fingerprintIsEnabled = true;
  final _fingerprintIsEnabledFetcher = PublishSubject<bool>();
  int _time = 31;
  final _timeFetcher = PublishSubject<int>();

  get fingerprintIsEnabled => _fingerprintIsEnabled;
  get fingerprintIsEnabledFetcher => _fingerprintIsEnabledFetcher.stream;
  Observable<int> get time => _timeFetcher.stream;
  Observable<List<BiometricType>> get availableBiometrics => _availableBiometricsFetcher.stream;

  void disableFingerprint() {
    _fingerprintIsEnabled = false;
    _fingerprintIsEnabledFetcher.sink.add(_fingerprintIsEnabled);
    _enableTimer();
  }

  void _enableTimer() {
    _time = 31;
    _timeFetcher.sink.add(_time);
    Timer timer;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      _time--;
      if (_time < 1) {
        timer.cancel();
        _enableFingerprint();
      } else
        _timeFetcher.sink.add(_time);
    });
  }

  void _enableFingerprint() {
    _fingerprintIsEnabled = true;
    _fingerprintIsEnabledFetcher.sink.add(_fingerprintIsEnabled);
  }

  void fetchAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
    _availableBiometricsFetcher.sink.add(availableBiometrics);
  }
  
  Future<bool> authenticateWithBiometrics() async {
    try {
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to show account balance');
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
      return null;
    }
  }
  
  void dispose() {
    _availableBiometricsFetcher.close();
    _fingerprintIsEnabledFetcher.close();
    _timeFetcher.close();
  }
}