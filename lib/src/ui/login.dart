import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_project_bloc/src/blocs/login_bloc.dart';
import 'package:my_project_bloc/src/ui/establishment_list.dart';
import 'package:my_project_bloc/src/ui/movie_list.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginBloc = LoginBloc();
  
  @override
  void initState() {
    super.initState();
    loginBloc.fetchAvailableBiometrics();
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Container(
      child: Center(
        child: StreamBuilder(
          stream: loginBloc.availableBiometrics,
          builder: (context, AsyncSnapshot<List<BiometricType>> snapshot) {
            if (snapshot.hasData) {
              return _buildWidgetLocalAuth(snapshot.data);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Loading')
              ],
            );
          },
        )
      ),
    );
  }

  _buildWidgetLocalAuth(List<BiometricType> data) {
    List<Widget> childrens = [];
    if (data.contains(BiometricType.face)) {
      Widget faceId = GestureDetector(
        onTap: () => _authenticateWithBiometrics(),
        child: Icon(
          Icons.face,
          size: 100,
        ),
      );
      childrens.add(faceId);
    }

    if (data.contains(BiometricType.face) && data.contains(BiometricType.fingerprint)) {
      Widget sizedBox = SizedBox(
        width: 40,
      );
      childrens.add(sizedBox);
    }

    if (data.contains(BiometricType.fingerprint)) {
      Widget fingerPrint = StreamBuilder(
        stream: loginBloc.fingerprintIsEnabledFetcher,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if ((snapshot.hasData && snapshot.data) || loginBloc.fingerprintIsEnabled) {
            return GestureDetector(
              onTap: () async {
                bool didAuthenticate = await _authenticateWithBiometrics();
                if (didAuthenticate == null)
                  loginBloc.disableFingerprint();
                else if (didAuthenticate) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EstablishmentList()
                  ));
                }
              },
              child: Icon(
                Icons.fingerprint,
                size: 100,
              ),
            );
          } else if (snapshot.hasData && !snapshot.data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.fingerprint,
                  size: 100,
                ),

                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(width: 30,),
                    StreamBuilder(
                      stream: loginBloc.time,
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData)
                          return Text("Aguarde ${snapshot.data} segundos.");
                        else
                          return Container();
                      },
                    )
                    //Text('Aguarde 30 segundos.')
                  ],
                )
              ],
            );
          }
          return Container();
        },
      );
      childrens.add(fingerPrint);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: childrens,
    );
  }

  Future<bool> _authenticateWithBiometrics() async {
    return await loginBloc.authenticateWithBiometrics();
  }
}