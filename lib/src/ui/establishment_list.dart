import 'package:flutter/material.dart';
import 'package:my_project_bloc/src/blocs/establishment_list_bloc.dart';

class EstablishmentList extends StatefulWidget {
  @override
  _EstablishmentListState createState() => _EstablishmentListState();
}

class _EstablishmentListState extends State<EstablishmentList> {
  EstablishmentListBloc bloc = EstablishmentListBloc();

  @override
  void initState() {
    super.initState();
    bloc.initSpeechRecognizer();
    bloc.initializeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Establishments'
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => bloc.record(),
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.mic
              ),
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.location_on,
                              size: 60,
                            ),
                          )
                        ],
                      ),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'FI Sistemas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                )
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: <Widget>[
                                Text(
                                  'Av. José Ferrari Secondo, 521 - antigo 720 - Jardim Vale das Rosas, Araraquara - SP, 14806-053'
                                )
                              ],
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}