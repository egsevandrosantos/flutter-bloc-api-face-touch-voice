class ItemModel {
  int _page;
  int _totalResults;
  int _totalPages;
  List<_Result> _results = List<_Result>();

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    _page = parsedJson['page'];
    _totalResults = parsedJson['total_results'];
    _totalPages = parsedJson['total_pages'];
    for (int i = 0, l = parsedJson['results'].length; i < l; i++) {
      _results.add(_Result(parsedJson['results'][i]));
    }
  }

  int get page => _page;
  int get totalResults => _totalResults;
  int get totalPages => _totalPages;
  List<_Result> get results => _results;
}

class _Result {
  int _voteCount;
  int _id;
  bool _video;
  double _voteAverage;
  String _title;
  double _popularity;
  String _posterPath;
  String _originalLanguage;
  String _originalTitle;
  List<int> _genreIds = List<int>();
  String _backdropPath;
  bool _adult;
  String _overview;
  String _releaseDate;

  _Result(result) {
    _voteCount = result['vote_count'];
    _id = result['id'];
    _video = result['video'];
    _voteAverage = result['vote_average'];
    _title = result['title'];
    _popularity = result['popularity'];
    _posterPath = result['poster_path'];
    _originalLanguage = result['original_language'];
    _originalTitle = result['original_title'];
    for (int i = 0, l = result['genre_ids'].length; i < l; i++) {
      _genreIds.add(result['genre_ids'][i]);
    }
    _backdropPath = result['backdrop_path'];
    _adult = result['adult'];
    _overview = result['overview'];
    _releaseDate = result['releaseDate'];
  }

  int get voteCount => _voteCount;
  int get id => _id;
  bool get video => _video;
  double get voteAverage => _voteAverage;
  String get title => _title;
  double get popularity => _popularity;
  String get posterPath => _posterPath;
  String get originalLanguage => _originalLanguage;
  String get originalTitle => _originalTitle;
  List<int> get genreIds => _genreIds;
  String get backdropPath => _backdropPath;
  bool get adult => _adult;
  String get overview => _overview;
  String get releaseDate => _releaseDate;
}