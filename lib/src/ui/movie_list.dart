import 'package:flutter/material.dart';
import 'package:my_project_bloc/src/blocs/movies_bloc.dart';
import 'package:my_project_bloc/src/models/item_model.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final bloc = MoviesBloc();
  
  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  void loadMovies() {
    print('load movies');
    bloc.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    print('Build');
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies')
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.autorenew
        ),
        onPressed: () => loadMovies(),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.results.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2
      ),
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].posterPath}',
          fit: BoxFit.cover,
        );
      },
    );
  }
}